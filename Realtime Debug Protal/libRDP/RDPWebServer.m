//
//  RDPWebServer.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "RDPWebServer.h"
#import "WebServiceBaseController.h"
#import "UIDevice-Hardware.h"


@implementation RDPWebServer

- (id)init
{
    self = [super init];
    
    if(self){
        
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"RDPBundle" ofType:@"bundle"];
        NSString* websitePath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"Website" ofType:nil];
        
        [self addHandlerForBasePath:@"/" localPath:websitePath indexFilename:@"index.html" cacheAge:0];
        
        [self addHandlerForMethod:@"GET"
                        pathRegex:@"/api/.*"
                     requestClass:[GCDWebServerRequest class]
                     processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request)
        {
                         
             NSError *e = nil;
             NSDictionary *response = [self parseRequest:request error:&e];
             
             if (response && !e) {
                 
                 NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"state":@"success",@"data":response} options:0 error:&e];
                 
                 if (data && e == nil)
                 {
                     NSString *jsonString = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
                     
                     return [GCDWebServerDataResponse responseWithText:jsonString];

                 }
             }

             NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                             @"state"   :@"error",
                             @"code"    :@(e.code),
                             @"message" :[e.userInfo objectForKey:@"message"]
                             } options:0 error:&e];
            
             if (data && e == nil)
             {
                 NSString *jsonString = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
                 
                 return [GCDWebServerDataResponse responseWithText:jsonString];
             }

             return nil;
         
         }];
    }
    return self;
}


- (NSDictionary *)parseRequest:(GCDWebServerRequest *)request error:(NSError **)error
{
    NSString *service = request.URL.lastPathComponent;
    if (service == nil) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:100 userInfo:@{@"message":@"serivce cannot be empty."}];
        return nil;
    }
    
    NSString *controllerClassName = [service stringByAppendingString:@"Controller"];
    
    Class clazz = NSClassFromString(controllerClassName);
    if (clazz == nil) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:101 userInfo:@{@"message":@"serivce can not be found."}];
        return nil;
    }
    
    id controller = [[[clazz alloc]init]autorelease];
    if (![controller respondsToSelector:@selector(handleRequest:)]) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:102 userInfo:@{@"message":@"serivce is not available."}];
        return nil;
    }

    return [controller handleRequest:request];
}



- (BOOL)start
{
    NSString *IPString = nil;
    
#if TARGET_IPHONE_SIMULATOR
    
    //Simulator
    IPString = @"127.0.0.1";
    
#else
    
    // Device
    IPString = [[UIDevice currentDevice]getIPAddress];
    
#endif
    
    if (IPString) {
        
//        UIWindow *statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//        statusWindow.windowLevel = UIWindowLevelStatusBar + 1;
//        statusWindow.hidden = NO;
//        statusWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1];
//        [statusWindow makeKeyAndVisible];
        
        UIView *statusWindow = [[[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 20)]autorelease];
        statusWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusWindow.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:statusWindow];

        UILabel *_tipContent = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 18)]autorelease];
        [_tipContent setBackgroundColor:[UIColor clearColor]];
        [_tipContent setTextColor:[UIColor whiteColor]];
        [_tipContent setFont:[UIFont systemFontOfSize:12]];
        [_tipContent setTextAlignment:NSTextAlignmentCenter];
        [statusWindow addSubview:_tipContent];
        
        _tipContent.text = [NSString stringWithFormat:@"RDP: http://%@:8080 (use Chrome/Safari)",IPString];
        
        double delayInSeconds = 20.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.3 animations:^{
                
                statusWindow.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [statusWindow removeFromSuperview];
            }];
        });

    }
    
    return [super start];
}

@end

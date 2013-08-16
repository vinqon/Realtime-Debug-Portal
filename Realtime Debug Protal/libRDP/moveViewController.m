//
//  moveViewController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "moveViewController.h"
#import "UIView+Observer.h"
#import "NSObject+ViewTree.h"

@implementation moveViewController

- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request;
{
    // get the view by address
    int address = [[request.query objectForKey:@"address"]intValue];
    UIView *view = [self view:[UIApplication sharedApplication] withAddress:address];
    
    if (view == nil) return @{@"msg":@"can not find the view."};
    
    NSString *jsonStr = [request.query objectForKey:@"info"];

    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF16StringEncoding] options:0 error:nil];
    
    if (info) {
        
        [view performSelectorOnMainThread:@selector(fromDict:) withObject:info waitUntilDone:NO];
        
        return @{@"msg":@"success"};
        
    }else{
        
        return @{@"msg":@"info can not be empty."};
    }
    
//    int address = [[request.query objectForKey:@"address"]intValue];
//    NSNumber *x = [request.query objectForKey:@"x"];
//    NSNumber *y = [request.query objectForKey:@"y"];
//    NSNumber *w = [request.query objectForKey:@"w"];
//    NSNumber *h = [request.query objectForKey:@"h"];
//    NSNumber *hidden = [request.query objectForKey:@"hidden"];
//    
//    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
//    UIView *view = [self view:window withAddress:address];
//    
//    if (view == nil) {
//        return @{@"msg":@"can not find the view."};
//    }
//    
//    if (x || y || w || y) {
//        
//        //run on the main thread, or it will be showly.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CGRect frame = view.frame;
//            if(x) frame.origin.x = [x integerValue];
//            if(y) frame.origin.y = [y integerValue];
//            if(w) frame.size.width = [w integerValue];
//            if(h) frame.size.height = [h integerValue];
//            if([hidden boolValue]) view.hidden = !view.hidden;
//            view.frame = frame;
//            
//            [UIView setNeedsRefresh:YES];
//        });
//    }else{
//        return @{@"msg":@"x or y params must be provided."};
//    }
//    return @{@"msg":@"move successfully."};
}


// find out the view by address, obj can be a UIView or UIApplication object
- (UIView *)view:(id)obj withAddress:(int)address
{
    if ([obj isKindOfClass:[UIView class]]) {
        
        UIView *view = (UIView *)obj;
        
        if ((int)view == address)
        {
            return view;
        }
        
        for (UIView *v in view.subviews)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    if ([obj isKindOfClass:[UIApplication class]]) {
        
        UIApplication *app = (UIApplication *)obj;
        
        for (UIView *v in app.windows)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    return nil;
}

@end

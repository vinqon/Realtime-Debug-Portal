//
//  loadLogController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-27.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//


#import "loadLogController.h"
#import "UIDevice-Hardware.h"
#import "MemoryModel.h"

#define autoLogSystemInfo 1


static NSMutableArray   *logContentPool;
static NSTimer          *systemInfoLogTimer;
static BOOL             logChanged;

@implementation loadLogController



- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request
{
    
#if autoLogSystemInfo
    
    if (systemInfoLogTimer == nil) {
        systemInfoLogTimer = [[NSTimer timerWithTimeInterval:1
                                                      target:[self class]
                                                    selector:@selector(RDPLogSystemInfo)
                                                    userInfo:nil
                                                     repeats:YES]retain];
        
        [[NSRunLoop mainRunLoop]addTimer:systemInfoLogTimer forMode:NSRunLoopCommonModes];
    }
#endif
    
    NSArray *list = [[self class]loadLog];
    
    if(list != nil){
        
        return @{
                 @"content": list,
                 @"code"   :@"200"
                 };
    }else{
        
        return @{
                 @"code"    :@"404"
                 };
    }
}


#pragma mark - RDPLoger for Client -

+ (void)RDPLogSystemInfo
{
    
//    [self addLog:@{
//     @"type"    :@"userlog",
//     @"content"  :[@([MemoryModel currentMemory].totalMemory - [[MemoryModel currentMemory]freeMemory]) description],
//     @"date"    :@([[NSDate date]timeIntervalSince1970])
//     }];
//    
//    return;
    
    [self addLog:@{
         @"type"    :@"systeminfo",
         @"cpu"     :@([[UIDevice currentDevice]CPUUsage]),
         @"memory"  :@([MemoryModel currentMemory].realMemory - [[MemoryModel currentMemory]freeMemory]),
         @"date"    :@([[NSDate date]timeIntervalSince1970])
     }];
}


+ (void)RDPLogWithObject:(id)obj
{
    [self addLog:@{
        @"type"     :@"userlog",
        @"content"  :[obj description],
        @"date"     :@([[NSDate date]timeIntervalSince1970])
     }];

}

+ (void)RDPLogWithFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args,format);
    va_end(args);
    
    NSString *content = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    NSDictionary *logDict = @{
                              @"type"     :@"userlog",
                              @"content"  :content,
                              @"date"     :@([[NSDate date]timeIntervalSince1970])
                              };
    [self addLog:logDict];
}


#pragma mark - Add & Load Log -

+ (void)addLog:(NSDictionary *)dict
{
    if (!dict) return;
    
    @synchronized(logContentPool){
        if (!logContentPool) {
            logContentPool = [[NSMutableArray alloc]initWithCapacity:100];
        }
        
        [logContentPool addObject:dict];
        
        // remove the last 50 object when the pool larger than 250
        if (logContentPool.count > 250) {
            [logContentPool removeObjectsInRange:NSMakeRange(0, 50)];
        }
        
        logChanged = YES;
    }
    
    return;
}

+ (NSArray *)loadLog
{
    NSMutableArray *_list = nil;
    
    @synchronized(logContentPool)
    {
        if (!logContentPool) {
            logContentPool = [[NSMutableArray alloc]initWithCapacity:100];
        }

        _list = [logContentPool mutableCopy];
        
        [logContentPool removeAllObjects];
        
        logChanged = NO;
    }

    return _list;
    
}

@end

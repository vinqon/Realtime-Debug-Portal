//
//  loadViewTreeController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "loadViewTreeController.h"
#import "highlightViewController.h"
#import "UIView+Observer.h"
#import "NSObject+ViewTree.h"

static BOOL firstLoad = YES;
static int timeStamp;

@implementation loadViewTreeController


- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request
{
    // if it's the first time to handle this controller, start obsever all the UIView
    if (firstLoad)
    {
        [UIView startObserving];
        
        firstLoad = NO;
    }
    
    //  the lastupdate is a timestamp indicated that whether it need refresh
    int lastUpdate = [[request.query objectForKey:@"lastupdate"]intValue];


    if ([UIView needsRefresh] == NO && lastUpdate == timeStamp)
    {
        return @{
                 
                 @"code":@(304)
                 
                 };

    }else{
        
        [UIView setNeedsRefresh:NO];
        
        timeStamp = [[NSDate date]timeIntervalSince1970];
        
        return @{
                 
                @"code":        @(200),
                @"lastUpdate":  [NSString stringWithFormat:@"%d",timeStamp],
                @"content":     [[UIApplication sharedApplication]toDict]
                
                };
    }

}

@end

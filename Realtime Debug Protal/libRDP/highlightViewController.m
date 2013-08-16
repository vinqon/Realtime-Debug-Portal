//
//  highlightViewController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-28.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "highlightViewController.h"

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#endif
static HighlightView *highlightView;

@implementation HighlightView

- (NSMutableDictionary *)toDict
{
    return nil;
}


@end


@implementation highlightViewController

+ (HighlightView *)highlightView
{
    return highlightView;
}

- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request;
{
    int address = [[request.query objectForKey:@"address"]intValue];
    
    UIView *view = [self view:[UIApplication sharedApplication] withAddress:address];

    if (view == nil) {
        return @{@"msg":@"can not find the view."};
    }
    
    //这段放在主线程跑，不然会很慢
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!highlightView) {
            highlightView = [[HighlightView alloc]init];
            highlightView.backgroundColor = HEXRGBACOLOR(0x0081db, 0.4);
        }
        

        
        if (view != highlightView) {        
            if ([[view subviews]containsObject:highlightView]) {
                [highlightView removeFromSuperview];
                NSLog(@"take highlightView off");
            }else{
                highlightView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                [view addSubview:highlightView];
                NSLog(@"put highlightView on");

            }
        }
        

    });
    
    return @{@"msg":@"highlight successfully."};
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

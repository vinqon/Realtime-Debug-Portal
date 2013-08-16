//
//  WebServiceBaseController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "WebServiceBaseController.h"

@implementation WebServiceBaseController

- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request;
{
    [self doesNotRecognizeSelector:@selector(handleRequest:)];
    return nil;
}

@end

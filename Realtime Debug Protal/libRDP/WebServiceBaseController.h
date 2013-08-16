//
//  WebServiceBaseController.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDWebServer.h"

@interface WebServiceBaseController : NSObject

// All the subclass must override this method.
- (NSDictionary *)handleRequest:(GCDWebServerRequest *)request;

@end

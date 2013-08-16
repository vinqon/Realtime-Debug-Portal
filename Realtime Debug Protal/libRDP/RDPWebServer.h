//
//  RDPWebServer.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-20.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "GCDWebServer.h"

@interface RDPWebServer : GCDWebServer

- (BOOL)start;

- (void)stop;

@end

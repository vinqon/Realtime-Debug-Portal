//
//  RDPServer.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-19.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPServer : NSObject

// server Singleton
+ (instancetype)defaultServer;

// start the server and the return value indicates whether it runs successfully or not.
- (BOOL)start;

// stop the server
- (void)stop;


@end

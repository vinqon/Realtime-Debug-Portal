//
//  libRDP.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-19.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface RDP : NSObject

// start the server and the return value indicates whether it runs successfully or not.
+ (BOOL)startServer;

// stop the server
+ (void)stopServer;

// log
+ (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

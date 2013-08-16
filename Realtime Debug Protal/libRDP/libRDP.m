//
//  libRDP.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-19.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "libRDP.h"
#import "RDPWebServer.h"
#import "loadLogController.h"

@implementation RDP

+ (RDPWebServer *)sharedWebServer
{
    static dispatch_once_t onceToken;
    static RDPWebServer *_sharedWebServer;
    
    dispatch_once(&onceToken, ^{
        
        _sharedWebServer = [[RDPWebServer alloc]init];
        
    });
    
    return _sharedWebServer;
}

// start the server and the return value indicates whether it runs successfully or not.
+ (BOOL)startServer
{
    return [[self sharedWebServer]start];
}

// stop the server
+ (void)stopServer
{
    return [[self sharedWebServer]stop];
}

// log
+ (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list args;
    va_start(args,format);
    
    va_end(args);
    
    NSString *content = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    
    [loadLogController RDPLogWithObject:content];
}

@end

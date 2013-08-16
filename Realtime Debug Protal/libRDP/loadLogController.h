//
//  loadLogController.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-27.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "WebServiceBaseController.h"


@interface loadLogController : WebServiceBaseController

+ (void)RDPLogWithObject:(id)obj;

+ (void)RDPLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);


@end

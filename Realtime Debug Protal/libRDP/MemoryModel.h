//
//  MemoryModel.h
//  MemoryCleaner
//
//  Created by Feather Chan on 13-3-1.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryModel : NSObject

+ (MemoryModel *)currentMemory;

@property (nonatomic) float freeMemory;
@property (nonatomic) float activeMemory;
@property (nonatomic) float inactiveMemory;
@property (nonatomic) float wireMemory;

@property (nonatomic,readonly) float usedMemory;
@property (nonatomic,readonly) float totalMemory;
@property (nonatomic,readonly) float realMemory;

@end

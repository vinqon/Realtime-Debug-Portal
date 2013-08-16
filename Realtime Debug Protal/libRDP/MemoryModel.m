//
//  MemoryModel.m
//  MemoryCleaner
//
//  Created by Feather Chan on 13-3-1.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "MemoryModel.h"
#import "UIDevice-Hardware.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

static MemoryModel *currentMemory;

@implementation MemoryModel

static void print_free_memory () {


}

+ (MemoryModel *)currentMemory
{
    if (!currentMemory) {
        currentMemory = [[MemoryModel alloc]init];
    }

    vm_size_t pagesize;
    
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    currentMemory.freeMemory =  (vm_stat.free_count * pagesize)/1024/1024;
    currentMemory.activeMemory = (vm_stat.active_count * pagesize)/1024/1024;
    currentMemory.inactiveMemory = (vm_stat.inactive_count * pagesize)/1024/1024;
    currentMemory.wireMemory = (vm_stat.wire_count * pagesize)/1024/1024;
    
    return currentMemory;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"free:%.1f,used:%.1f,total:%.1f",self.freeMemory,self.usedMemory,self.totalMemory];
}

- (float)usedMemory
{
    return self.activeMemory + self.inactiveMemory + self.wireMemory;
}

- (float)totalMemory
{
    return self.usedMemory + self.freeMemory;
}

- (float)realMemory
{
    return [[UIDevice currentDevice]totalMemory]/1024/1024;
}


@end

//
//  GlobalModel.m
//  Traffic
//
//  Created by Tom Fryer on 04/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "GlobalModel.h"
#import "WS_JobTaskAllocation.h"

@implementation GlobalModel

static GlobalModel *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (GlobalModel *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        self.pageNumber=1;
    }
    
    return self;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)printOutTaskAllocations{
    for (WS_JobTaskAllocation *jt in self.taskAllocations) {
        NSLog(@"Task Allocation:%@",jt);
        NSLog(@"%@:%@", @"description", jt.taskDescription);
        NSLog(@"%@:%@", @"happyRating", jt.happyRating);
        NSLog(@"%@:%d", @"isTaskComplete", jt.isTaskComplete);
        NSLog(@"%@:%@", @"taskDeadline", jt.taskDeadline);

    }
}

@end

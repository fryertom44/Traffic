//
//  GlobalModel.m
//  Traffic
//
//  Created by Tom Fryer on 04/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "GlobalModel.h"
#import "WS_JobTask.h"

@implementation GlobalModel

@synthesize timeEntries=_timeEntries;
@synthesize allocatedTasks=_allocatedTasks;

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
        // Work your initialising magic here as you normally would
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

- (NSMutableArray *)timeEntries {
    if(_timeEntries==nil) {
        _timeEntries = [[NSMutableArray alloc]init];
    }
    return _timeEntries;
}

- (NSMutableArray *)allocatedTasks {
    if(_allocatedTasks==nil) {
        _allocatedTasks = [[NSMutableArray alloc]init];
    }
    return _allocatedTasks;
}

-(void)printOutTasks{
    for (WS_JobTask *jt in self.allocatedTasks) {
        NSLog(@"Job Task:%@",jt);
        NSLog(@"%@:%@", @"description", jt.taskDescription);
        NSLog(@"%@:%@", @"happyRating", jt.happyRating);
        NSLog(@"%@:%d", @"isTaskComplete", jt.isTaskComplete);
        NSLog(@"%@:%@", @"taskDeadline", jt.taskDeadline);

    }
}

@end

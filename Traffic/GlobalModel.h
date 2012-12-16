//
//  GlobalModel.h
//  Traffic
//
//  Created by Tom Fryer on 04/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WS_TrafficEmployee.h"
#import "WS_JobTask.h"

@interface GlobalModel : NSObject

+ (GlobalModel *)sharedInstance;
- (void)printOutTaskAllocations;

@property (nonatomic,strong) NSMutableArray *timeEntries;
@property (nonatomic,strong) NSMutableArray *taskAllocations;
@property (nonatomic,strong) WS_TrafficEmployee *loggedInEmployee;
@property (nonatomic,strong) WS_JobTask *selectedJobTask;
@property (nonatomic,strong) NSMutableData *selectedJobAsData;
@end

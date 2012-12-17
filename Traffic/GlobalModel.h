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
#import "WS_JobTaskAllocation.h"
#import "WS_Job.h"
#import "WS_Client.h"
#import "WS_JobDetail.h"
#import "WS_TimeEntry.h"
#import "WS_Project.h"

@interface GlobalModel : NSObject

+ (GlobalModel *)sharedInstance;
- (void)printOutTaskAllocations;

@property (nonatomic,strong) NSMutableArray *timeEntries;
@property (nonatomic,strong) NSMutableArray *taskAllocations;
@property (nonatomic,strong) NSMutableData *selectedJobAsData;

@property (nonatomic,strong) WS_TrafficEmployee *loggedInEmployee;
@property (nonatomic,strong) WS_TrafficEmployee *selectedOwner;
@property (nonatomic,strong) WS_JobTask *selectedJobTask;
@property (nonatomic,strong) WS_JobTaskAllocation *selectedJobTaskAllocation;
@property (nonatomic,strong) WS_Client *selectedClient;
@property (nonatomic,strong) WS_Job *selectedJob;
@property (nonatomic,strong) WS_JobDetail *selectedJobDetail;
@property (nonatomic,strong) WS_Project *selectedProject;
@property (nonatomic,strong) WS_TimeEntry *timesheet;

@end

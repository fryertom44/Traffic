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

#pragma mark - lists
@property (nonatomic,strong) NSMutableArray *timeEntries;
@property (nonatomic,strong) NSMutableArray *taskAllocations;
@property (nonatomic,strong) NSMutableArray *clients;
@property (nonatomic,strong) NSMutableArray *jobs;
@property (nonatomic,strong) NSMutableArray *jobDetails;
@property (nonatomic,strong) NSMutableArray *projects;

#pragma mark - Dictionaries for fast lookups
@property (nonatomic,strong) NSMutableDictionary *clientsDictionary;
@property (nonatomic,strong) NSMutableDictionary *jobsDictionary;
@property (nonatomic,strong) NSMutableDictionary *jobDetailsDictionary;
@property (nonatomic,strong) NSMutableDictionary *jobTasksDictionary;
@property (nonatomic,strong) NSMutableDictionary *projectsDictionary;

@property (nonatomic) int pageNumber;

#pragma mark - Current selection/state
@property (nonatomic,strong) WS_TrafficEmployee *loggedInEmployee;
@property (nonatomic,strong) WS_TrafficEmployee *selectedOwner;
@property (nonatomic,strong) WS_JobTask *selectedJobTask;
@property (nonatomic,retain) WS_JobTaskAllocation *selectedJobTaskAllocation;
@property (nonatomic,strong) WS_Client *selectedClient;
@property (nonatomic,strong) WS_Job *selectedJob;
@property (nonatomic,strong) WS_JobDetail *selectedJobDetail;
@property (nonatomic,strong) WS_Project *selectedProject;
@property (nonatomic,strong) WS_TimeEntry *timesheet;

#pragma mark - Storing 'Timer' state
@property (weak, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSDate *timerStartDate;
@property (nonatomic) double timeElapsedInterval;
@property BOOL isRecordingTime;
@end

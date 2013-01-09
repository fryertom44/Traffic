//
//  WS_JobTask.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"
#import "WS_Client.h"
#import "WS_TimeEntry.h"
#import "WS_JobDetail.h"
#import "WS_Job.h"
#import "WS_Project.h"

@interface WS_JobTaskAllocation : BaseObject <NSCoding>

@property (nonatomic,retain) NSDate *dependencyTaskDeadline;
@property (nonatomic,retain) NSString* externalCalendarTag;
@property (nonatomic,retain) NSString* externalCalendarUUID;
@property (nonatomic,retain) NSString* uuid;
@property (nonatomic,strong) NSString* taskDescription;
@property (nonatomic,retain) NSString* jobStageDescription;
@property (nonatomic,retain) NSString* jobStageUUID;
@property (nonatomic,retain) NSString* happyRating;
@property (nonatomic,retain) NSNumber* happyRatingWasChanged;
@property (nonatomic,retain) NSDate* taskDeadline;
@property (nonatomic,retain) NSNumber* isTaskComplete;
@property (nonatomic,retain) NSNumber* jobTaskAllocationGroupId;
@property (nonatomic,retain) NSNumber* jobTaskId;
@property (nonatomic,retain) NSNumber* jobId;
@property (nonatomic,retain) NSNumber* trafficEmployeeId;
@property (nonatomic,retain) NSNumber* totalTimeLoggedMinutes;
@property (nonatomic,retain) NSNumber* durationInMinutes;
@property (nonatomic,retain) NSString* internalNote;
@property (nonatomic,retain) NSNumber* isTaskMilestone;
@property (nonatomic,retain) NSMutableArray *allocationIntervals;
@property (nonatomic,retain) WS_TimeEntry *timesheet;

#pragma mark - enriched properties
@property (nonatomic,retain) WS_Client *client;
@property (nonatomic,retain) WS_JobDetail *jobDetail;
@property (nonatomic,retain) WS_Job *job;
@property (nonatomic,retain) WS_Project *project;

-(int)daysUntilDeadline;
@end

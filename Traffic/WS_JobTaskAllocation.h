//
//  WS_JobTask.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"
#import "WS_Client.h"

@interface WS_JobTaskAllocation : BaseObject

@property (nonatomic,retain) NSDate *dependencyTaskDeadline;
@property (nonatomic,retain) NSString* externalCalendarTag;
@property (nonatomic,retain) NSString* externalCalendarUUID;
@property (nonatomic,retain) NSString* uuid;
@property (nonatomic,retain) NSString* taskDescription;
@property (nonatomic,retain) NSString* jobStageDescription;
@property (nonatomic,retain) NSString* jobStageUUID;
@property (nonatomic,retain) NSString* happyRating;
@property (nonatomic) BOOL happyRatingWasChanged;
@property (nonatomic,retain) NSDate* taskDeadline;
@property (nonatomic) BOOL isTaskComplete;
@property (nonatomic,retain) NSNumber* jobTaskAllocationGroupId;
@property (nonatomic,retain) NSNumber* jobTaskId;
@property (nonatomic,retain) NSNumber* jobId;
@property (nonatomic,retain) NSNumber* trafficEmployeeId;
@property (nonatomic,retain) NSNumber* totalTimeLoggedMinutes;
@property (nonatomic, retain) NSNumber* durationInMinutes;
@property (nonatomic,retain) NSString* internalNote;
@property (nonatomic) BOOL isTaskMilestone;
@property (nonatomic,retain) NSMutableArray *allocationIntervals;

@property (nonatomic,retain)WS_Client *client;

-(int)daysUntilDeadline;
-(int)daysUntilDeadlineUnsigned;
@end

//
//  WS_JobTask.h
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"
#import "Money.h"

@interface WS_JobTask : BaseObject <NSCoding>

@property (nonatomic,retain) NSNumber* jobTaskId;
@property (nonatomic,retain) NSNumber* version;
@property (nonatomic,retain) NSString* jobTaskDescription;
@property (nonatomic,retain) NSString* internalNote;
@property (nonatomic,retain) NSNumber* quantity;
@property (nonatomic,retain) NSNumber* chargeBandId;
@property (nonatomic,retain) NSNumber* jobId;
@property (nonatomic,retain) NSDate* jobTaskCompletionDate;
@property (nonatomic,retain) NSNumber* studioAllocationMinutes;
@property (nonatomic,retain) NSDate* taskDeadline;
@property (nonatomic,retain) NSDate* taskStartDate;
@property (nonatomic,retain) NSString* jobStageDescription;
@property (nonatomic,retain) NSNumber* durationMinutes;
@property (nonatomic,retain) NSNumber* totalTimeLoggedMinutes;
@property (nonatomic,retain) NSNumber* totalTimeLoggedBillableMinutes;
@property (nonatomic,retain) NSNumber* totalTimeAllocatedMinutes;
@property (nonatomic,retain) Money* cost;
@property (nonatomic,retain) Money* rate;
@property (nonatomic,retain) Money* rateOtherCurrency;
@property (nonatomic,retain) Money* billableNet;

@end

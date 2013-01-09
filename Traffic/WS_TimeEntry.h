//
//  WS_TimeEntry.h
//  traffic
//
//  Created by Tom Fryer on 12/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Money.h"
#import "BaseObject.h"

@interface WS_TimeEntry : BaseObject <NSCoding>

@property (nonatomic, retain) NSNumber *timeEntryId;
@property (nonatomic, retain) NSNumber *jobTaskId;
@property (nonatomic, retain) NSNumber *trafficEmployeeId;
@property (nonatomic, retain) NSNumber *jobId;
@property (nonatomic, retain) NSNumber *jobTaskAllocationGroupId;
@property (nonatomic, retain) NSNumber *chargeBandId;
@property (nonatomic, retain) NSNumber *billable;
@property (nonatomic, retain) NSNumber *exported;
@property (nonatomic, retain) NSNumber *lockedByApproval;
@property (nonatomic, retain) NSNumber *lockedByApprovalEmployeeId;
@property (nonatomic, retain) NSDate *lockedByApprovalDate;
@property (nonatomic, retain) NSNumber *timesheetWasChanged;
@property (nonatomic, retain) NSNumber *isTaskComplete;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSNumber *minutes;
@property (nonatomic, retain) NSString *taskDescription;
@property (nonatomic, retain) Money *taskRate;
@property (nonatomic, retain) Money *valueOfTimeEntry;
@property (nonatomic, retain) Money *timeEntryCost;
@property (nonatomic, retain) Money *timeEntryPersonalRate;
@property (nonatomic, retain) NSDate *dateModified;

#pragma mark - Storing 'Timer' state
@property (weak, nonatomic) NSTimer *myTimer;
@property (nonatomic, retain) NSDate *timerStartDate;
@property (nonatomic) NSTimeInterval timeElapsedInterval;
@property BOOL isRecordingTime;

- (void)updateTimeElapsed;

@end

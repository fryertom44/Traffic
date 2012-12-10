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

@interface WS_TimeEntry : BaseObject {
	
	NSNumber* timeEntryId;
	NSNumber* jobTaskId;
	NSNumber* trafficEmployeeId;
	NSNumber* jobId;
	NSNumber* allocationGroupId;
	NSNumber* chargebandId;
	bool billable;
	bool exported;
	bool lockedByApproval;
	NSString*comment;
    NSString*happyRating;
    NSDate *startTime;
	NSDate *endTime;
	NSNumber* minutes;
	NSString*taskDescription;
	Money*taskRate;
	Money*valueOfTimeEntry;
	Money*timeEntryCost;
	NSDate*dateModified;
    NSNumber* version;
}

@property (nonatomic, retain) NSNumber* timeEntryId;
@property (nonatomic, retain) NSNumber* jobTaskId;
@property (nonatomic, retain) NSNumber* trafficEmployeeId;
@property (nonatomic, retain) NSNumber* jobId;
@property (nonatomic, retain) NSNumber* allocationGroupId;
@property (nonatomic, retain) NSNumber* chargebandId;
@property bool billable;
@property bool exported;
@property bool lockedByApproval;
@property (nonatomic, retain) NSString*comment;
@property (nonatomic, retain) NSString*happyRating;
@property (nonatomic, retain) NSDate*startTime;
@property (nonatomic, retain) NSDate*endTime;
@property (nonatomic, retain) NSNumber* minutes;
@property (nonatomic, retain) NSString*taskDescription;
@property (nonatomic, retain) Money*taskRate;
@property (nonatomic, retain) Money*valueOfTimeEntry;
@property (nonatomic, retain) Money*timeEntryCost;
@property (nonatomic, retain) NSDate*dateModified;
@property (nonatomic, retain) NSNumber* version;

-(NSString*)happyRatingImage;
-(void)nextHappyRating;

@end

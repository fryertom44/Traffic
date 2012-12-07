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
	
	 int timeEntryId;
	 int jobTaskId;
	 int trafficEmployeeId;
	 int jobId;
	 int allocationGroupId;
	 int chargebandId;
	bool billable;
	bool exported;
	bool lockedByApproval;
	NSString*comment;
    NSString*happyRating;
    NSDate *startTime;
	NSDate *endTime;
	 int minutes;
	NSString*taskDescription;
	Money*taskRate;
	Money*valueOfTimeEntry;
	Money*timeEntryCost;
	NSDate*dateModified;
    int version;
}

@property int timeEntryId;
@property int jobTaskId;
@property int trafficEmployeeId;
@property int jobId;
@property int allocationGroupId;
@property int chargebandId;
@property bool billable;
@property bool exported;
@property bool lockedByApproval;
@property (nonatomic, retain)NSString*comment;
@property (nonatomic, retain)NSString*happyRating;
@property (nonatomic, retain)NSDate*startTime;
@property (nonatomic, retain)NSDate*endTime;
@property int minutes;
@property (nonatomic, retain)NSString*taskDescription;
@property (nonatomic, retain)Money*taskRate;
@property (nonatomic, retain)Money*valueOfTimeEntry;
@property (nonatomic, retain)Money*timeEntryCost;
@property (nonatomic, retain)NSDate*dateModified;
@property int version;

-(NSString*)happyRatingImage;
-(void)nextHappyRating;

@end

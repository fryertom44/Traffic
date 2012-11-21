//
//  WS_TimeEntry.m
//  traffic
//
//  Created by Tom Fryer on 12/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_TimeEntry.h"


@implementation WS_TimeEntry

@synthesize timeEntryId,jobTaskId,trafficEmployeeId,jobId,allocationGroupId,chargebandId,billable,exported,lockedByApproval,comment,endTime,minutes,taskDescription,taskRate,valueOfTimeEntry,timeEntryCost,dateModified,version;

@synthesize startTime = _startTime;

- (NSDate *)startTime {
    if (_startTime) {
        return _startTime;
    } else {
        return [[NSDate alloc] init];
    }
}
@end

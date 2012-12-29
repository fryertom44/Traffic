//
//  WS_TimeEntry.m
//  traffic
//
//  Created by Tom Fryer on 12/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_TimeEntry.h"

@implementation WS_TimeEntry

@synthesize timeEntryId,jobTaskId,trafficEmployeeId,jobId,allocationGroupId,chargebandId,billable,exported,lockedByApproval,comment,endTime,startTime,minutes,taskDescription,taskRate,valueOfTimeEntry,timeEntryCost,timeEntryPersonalRate,dateModified,version;

//@synthesize startTime = _startTime;
//
//- (NSDate *)startTime {
//    if (_startTime) {
//        return _startTime;
//    } else {
//        return [[NSDate alloc] init];
//    }
//}

- (id)init{
    self = [super init];
    
    if(self){
        billable = true;
        exported = false;
        lockedByApproval = false;
        comment = @"";
        taskDescription = @"";
        timeEntryId = [NSNumber numberWithInt:-1];
        version = [NSNumber numberWithInt:-1];
    }
    return self;
}

#pragma mark - NSCopying protocol implementation

-(id)copyWithZone:(NSZone *)zone
{
    WS_TimeEntry *copiedObject = [[WS_TimeEntry alloc]init];
    [copiedObject setAllocationGroupId:[self allocationGroupId]];
    [copiedObject setBillable:[self billable]];
    [copiedObject setChargebandId:[self chargebandId]];
    [copiedObject setComment:[self comment]];
    [copiedObject setDateModified:[self dateModified]];
    [copiedObject setEndTime:[self endTime]];
    [copiedObject setExported:[self exported]];
    [copiedObject setJobId:[self jobId]];
    [copiedObject setJobTaskId:[self jobTaskId]];
    [copiedObject setLockedByApproval:[self lockedByApproval]];
    [copiedObject setMinutes:[self minutes]];
    [copiedObject setStartTime:[self startTime]];
    [copiedObject setTaskDescription:[self taskDescription]];
    [copiedObject setTaskRate:[self taskRate]];
    [copiedObject setTimeEntryCost:[self timeEntryCost]];
    [copiedObject setTimeEntryPersonalRate:[self timeEntryPersonalRate]];
    [copiedObject setTimeEntryId:[self timeEntryId]];
    [copiedObject setTrafficEmployeeId:[self trafficEmployeeId]];
    [copiedObject setValueOfTimeEntry:[self valueOfTimeEntry]];
    [copiedObject setVersion:[self version]];
    return copiedObject;
}


@end

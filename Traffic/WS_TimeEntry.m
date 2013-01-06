//
//  WS_TimeEntry.m
//  traffic
//
//  Created by Tom Fryer on 12/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_TimeEntry.h"

@implementation WS_TimeEntry

//@synthesize timeEntryId,jobTaskId,trafficEmployeeId,jobId,allocationGroupId,chargebandId,billable,exported,lockedByApproval,comment,endTime,startTime,minutes,taskDescription,taskRate,valueOfTimeEntry,timeEntryCost,timeEntryPersonalRate,dateModified,version;

- (id)init{
    self = [super init];
    
    if(self){
        self.billable = [NSNumber numberWithBool:TRUE];
        self.exported = [NSNumber numberWithBool:FALSE];
        self.lockedByApproval = [NSNumber numberWithBool:FALSE];
        self.timesheetWasChanged = [NSNumber numberWithBool:FALSE];
        self.comment = @"";
        self.taskDescription = @"";
        self.timeEntryId = [NSNumber numberWithInt:-1];
        self.trafficVersion = [NSNumber numberWithInt:-1];
        self.valueOfTimeEntry = [[Money alloc]init];
        self.timeEntryCost = [[Money alloc]init];
        self.timeEntryPersonalRate = [[Money alloc]init];
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
    [copiedObject setTrafficVersion:[self trafficVersion]];
    return copiedObject;
}


@end

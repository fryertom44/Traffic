//
//  WS_TimeEntry.m
//  traffic
//
//  Created by Tom Fryer on 12/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_TimeEntry.h"

@implementation WS_TimeEntry

const NSTimeInterval unitOfTime=1;

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
        self.isRecordingTime = NO;
    }
    return self;
}

#pragma mark - NSCopying protocol implementation

-(id)copyWithZone:(NSZone *)zone
{
    WS_TimeEntry *copiedObject = [[WS_TimeEntry alloc]init];
    [copiedObject setJobTaskAllocationGroupId:[self jobTaskAllocationGroupId]];
    [copiedObject setBillable:[self billable]];
    [copiedObject setChargeBandId:[self chargeBandId]];
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

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_TimeEntry alloc] init];
    if (self != nil)
	{
		self.timeEntryId = [coder decodeObjectForKey:@"timeEntryId"];
		self.jobTaskId = [coder decodeObjectForKey:@"jobTaskId"];
		self.trafficEmployeeId = [coder decodeObjectForKey:@"trafficEmployeeId"];
        self.jobId = [coder decodeObjectForKey:@"jobId"];
        self.jobTaskAllocationGroupId = [coder decodeObjectForKey:@"jobTaskAllocationGroupId"];
        self.chargeBandId = [coder decodeObjectForKey:@"chargeBandId"];
		self.billable = [coder decodeObjectForKey:@"billable"];
		self.exported = [coder decodeObjectForKey:@"exported"];
        self.lockedByApproval = [coder decodeObjectForKey:@"lockedByApproval"];
        self.lockedByApprovalEmployeeId = [coder decodeObjectForKey:@"lockedByApprovalEmployeeId"];
        self.lockedByApprovalDate = [coder decodeObjectForKey:@"lockedByApprovalDate"];
//		self.timesheetWasChanged = [coder decodeObjectForKey:@"timesheetWasChanged"];
		self.isTaskComplete = [coder decodeObjectForKey:@"isTaskComplete"];
        self.comment = [coder decodeObjectForKey:@"comment"];
        self.startTime = [coder decodeObjectForKey:@"startTime"];
        self.endTime = [coder decodeObjectForKey:@"endTime"];
		self.minutes = [coder decodeObjectForKey:@"minutes"];
		self.taskDescription = [coder decodeObjectForKey:@"taskDescription"];
        self.taskRate = [coder decodeObjectForKey:@"taskRate"];
        self.valueOfTimeEntry = [coder decodeObjectForKey:@"valueOfTimeEntry"];
        self.timeEntryCost = [coder decodeObjectForKey:@"timeEntryCost"];
		self.timeEntryPersonalRate = [coder decodeObjectForKey:@"timeEntryPersonalRate"];
		self.dateModified = [coder decodeObjectForKey:@"dateModified"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.timeEntryId forKey:@"timeEntryId"];
	[coder encodeObject:self.jobTaskId forKey:@"jobTaskId"];
	[coder encodeObject:self.trafficEmployeeId forKey:@"trafficEmployeeId"];
    [coder encodeObject:self.jobId forKey:@"jobId"];
    [coder encodeObject:self.jobTaskAllocationGroupId forKey:@"jobTaskAllocationGroupId"];
    [coder encodeObject:self.chargeBandId forKey:@"chargeBandId"];
	[coder encodeObject:self.billable forKey:@"billable"];
	[coder encodeObject:self.exported forKey:@"exported"];
    [coder encodeObject:self.lockedByApproval forKey:@"lockedByApproval"];
    [coder encodeObject:self.lockedByApprovalEmployeeId forKey:@"lockedByApprovalEmployeeId"];
    [coder encodeObject:self.lockedByApprovalDate forKey:@"lockedByApprovalDate"];
	[coder encodeObject:self.isTaskComplete forKey:@"isTaskComplete"];
	[coder encodeObject:self.comment forKey:@"comment"];
    [coder encodeObject:self.startTime forKey:@"startTime"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.minutes forKey:@"minutes"];
	[coder encodeObject:self.taskDescription forKey:@"taskDescription"];
	[coder encodeObject:self.taskRate forKey:@"taskRate"];
    [coder encodeObject:self.valueOfTimeEntry forKey:@"valueOfTimeEntry"];
    [coder encodeObject:self.timeEntryCost forKey:@"timeEntryCost"];
    [coder encodeObject:self.timeEntryPersonalRate forKey:@"timeEntryPersonalRate"];
	[coder encodeObject:self.dateModified forKey:@"dateModified"];
    
}

- (void)updateTimeElapsed{
    if(self.isRecordingTime){
        self.timeElapsedInterval = self.timeElapsedInterval+unitOfTime;
    }
}


@end

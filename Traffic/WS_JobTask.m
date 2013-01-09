//
//  WS_JobTask.m
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_JobTask.h"

@implementation WS_JobTask

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_JobTask alloc] init];
    if (self != nil)
	{
		self.jobTaskId = [coder decodeObjectForKey:@"jobTaskId"];
		self.jobTaskDescription = [coder decodeObjectForKey:@"jobTaskDescription"];
		self.internalNote = [coder decodeObjectForKey:@"internalNote"];
        self.quantity = [coder decodeObjectForKey:@"quantity"];
        self.chargeBandId = [coder decodeObjectForKey:@"chargeBandId"];
        self.jobId = [coder decodeObjectForKey:@"jobId"];
        self.jobTaskCompletionDate = [coder decodeObjectForKey:@"jobTaskCompletionDate"];
        self.studioAllocationMinutes = [coder decodeObjectForKey:@"studioAllocationMinutes"];
        self.taskDeadline = [coder decodeObjectForKey:@"taskDeadline"];
        self.taskStartDate = [coder decodeObjectForKey:@"taskStartDate"];
        self.jobStageDescription = [coder decodeObjectForKey:@"jobStageDescription"];
        self.durationMinutes = [coder decodeObjectForKey:@"durationMinutes"];
        self.totalTimeLoggedMinutes = [coder decodeObjectForKey:@"totalTimeLoggedMinutes"];
        self.totalTimeLoggedBillableMinutes = [coder decodeObjectForKey:@"totalTimeLoggedBillableMinutes"];
        self.totalTimeAllocatedMinutes = [coder decodeObjectForKey:@"totalTimeAllocatedMinutes"];
        self.cost = [coder decodeObjectForKey:@"cost"];
        self.rate = [coder decodeObjectForKey:@"rate"];
        self.rateOtherCurrency = [coder decodeObjectForKey:@"rateOtherCurrency"];
        self.billableNet = [coder decodeObjectForKey:@"billableNet"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.jobTaskId forKey:@"jobTaskId"];
	[coder encodeObject:self.jobTaskDescription forKey:@"jobTaskDescription"];
	[coder encodeObject:self.internalNote forKey:@"internalNote"];
    [coder encodeObject:self.quantity forKey:@"quantity"];
    [coder encodeObject:self.chargeBandId forKey:@"chargeBandId"];
    [coder encodeObject:self.jobId forKey:@"jobId"];
    [coder encodeObject:self.jobTaskCompletionDate forKey:@"jobTaskCompletionDate"];
    [coder encodeObject:self.studioAllocationMinutes forKey:@"studioAllocationMinutes"];
    [coder encodeObject:self.taskDeadline forKey:@"taskDeadline"];
    [coder encodeObject:self.taskStartDate forKey:@"taskStartDate"];
    [coder encodeObject:self.jobStageDescription forKey:@"jobStageDescription"];
    [coder encodeObject:self.durationMinutes forKey:@"durationMinutes"];
    [coder encodeObject:self.totalTimeLoggedMinutes forKey:@"totalTimeLoggedMinutes"];
    [coder encodeObject:self.totalTimeLoggedBillableMinutes forKey:@"totalTimeLoggedBillableMinutes"];
    [coder encodeObject:self.totalTimeAllocatedMinutes forKey:@"totalTimeAllocatedMinutes"];
    [coder encodeObject:self.cost forKey:@"cost"];
    [coder encodeObject:self.rate forKey:@"rate"];
    [coder encodeObject:self.rateOtherCurrency forKey:@"rateOtherCurrency"];
    [coder encodeObject:self.billableNet forKey:@"billableNet"];
    
}

@end

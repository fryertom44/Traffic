//
//  WS_JobTask.m
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_JobTaskAllocation.h"

@implementation WS_JobTaskAllocation

- (id)init {
    self = [super init];
    if (self) {
        self.happyRatingWasChanged = FALSE;
        self.timesheet = [[WS_TimeEntry alloc]init];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    WS_JobTaskAllocation *copiedObject = [[WS_JobTaskAllocation alloc]init];
    [copiedObject setTaskDescription:[self taskDescription]];
    [copiedObject setHappyRating:[self happyRating]];
    [copiedObject setHappyRatingWasChanged:[self happyRatingWasChanged]];
    [copiedObject setIsTaskComplete:[self isTaskComplete]];
    [copiedObject setTaskDeadline:[self taskDeadline]];
    [copiedObject setJobTaskId:[self jobTaskId]];
    [copiedObject setJobId:[self jobId]];
    [copiedObject setTrafficEmployeeId:[self trafficEmployeeId]];
    [copiedObject setTotalTimeLoggedMinutes:[self totalTimeLoggedMinutes]];
    [copiedObject setInternalNote:[self internalNote]];
    return copiedObject;
}

-(NSInteger)daysUntilDeadline{
	NSDate *currentDate = [[NSDate alloc]init];
	return [self.taskDeadline timeIntervalSinceDate:currentDate] / (60*60*24);
}

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_JobTaskAllocation alloc] init];
    if (self != nil)
	{
		self.dependencyTaskDeadline = [coder decodeObjectForKey:@"dependencyTaskDeadline"];
		self.externalCalendarTag = [coder decodeObjectForKey:@"externalCalendarTag"];
		self.externalCalendarUUID = [coder decodeObjectForKey:@"externalCalendarUUID"];
        self.uuid = [coder decodeObjectForKey:@"uuid"];
        self.taskDescription = [coder decodeObjectForKey:@"taskDescription"];
        self.jobStageDescription = [coder decodeObjectForKey:@"jobStageDescription"];
		self.jobStageUUID = [coder decodeObjectForKey:@"jobStageUUID"];
		self.happyRating = [coder decodeObjectForKey:@"happyRating"];
        self.happyRatingWasChanged = [coder decodeObjectForKey:@"happyRatingWasChanged"];
        self.taskDeadline = [coder decodeObjectForKey:@"taskDeadline"];
        self.isTaskComplete = [coder decodeObjectForKey:@"isTaskComplete"];
		self.jobTaskAllocationGroupId = [coder decodeObjectForKey:@"jobTaskAllocationGroupId"];
		self.jobTaskId = [coder decodeObjectForKey:@"jobTaskId"];
        self.jobId = [coder decodeObjectForKey:@"jobId"];
        self.trafficEmployeeId = [coder decodeObjectForKey:@"trafficEmployeeId"];
        self.totalTimeLoggedMinutes = [coder decodeObjectForKey:@"totalTimeLoggedMinutes"];
		self.durationInMinutes = [coder decodeObjectForKey:@"durationInMinutes"];
		self.internalNote = [coder decodeObjectForKey:@"internalNote"];
        self.isTaskMilestone = [coder decodeObjectForKey:@"isTaskMilestone"];
        self.allocationIntervals = [coder decodeObjectForKey:@"allocationIntervals"];
        self.timesheet = [coder decodeObjectForKey:@"timesheet"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.dependencyTaskDeadline forKey:@"dependencyTaskDeadline"];
	[coder encodeObject:self.externalCalendarTag forKey:@"externalCalendarTag"];
	[coder encodeObject:self.externalCalendarUUID forKey:@"externalCalendarUUID"];
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [coder encodeObject:self.jobStageDescription forKey:@"jobStageDescription"];
	[coder encodeObject:self.jobStageUUID forKey:@"jobStageUUID"];
	[coder encodeObject:self.happyRating forKey:@"happyRating"];
    [coder encodeObject:self.happyRatingWasChanged forKey:@"happyRatingWasChanged"];
    [coder encodeObject:self.taskDeadline forKey:@"taskDeadline"];
    [coder encodeObject:self.isTaskComplete forKey:@"isTaskComplete"];
	[coder encodeObject:self.jobTaskAllocationGroupId forKey:@"jobTaskAllocationGroupId"];
	[coder encodeObject:self.jobTaskId forKey:@"jobTaskId"];
    [coder encodeObject:self.jobId forKey:@"jobId"];
    [coder encodeObject:self.trafficEmployeeId forKey:@"trafficEmployeeId"];
    [coder encodeObject:self.totalTimeLoggedMinutes forKey:@"totalTimeLoggedMinutes"];
	[coder encodeObject:self.durationInMinutes forKey:@"durationInMinutes"];
	[coder encodeObject:self.internalNote forKey:@"internalNote"];
    [coder encodeObject:self.isTaskMilestone forKey:@"isTaskMilestone"];
    [coder encodeObject:self.allocationIntervals forKey:@"allocationIntervals"];
    [coder encodeObject:self.timesheet forKey:@"timesheet"];

}

@end

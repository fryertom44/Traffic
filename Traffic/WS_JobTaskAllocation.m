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
//
//-(int)daysUntilDeadlineUnsigned{
//    return abs(self.daysUntilDeadline);
//}

@end

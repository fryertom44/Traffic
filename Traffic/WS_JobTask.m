//
//  WS_JobTask.m
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_JobTask.h"

@implementation WS_JobTask

@synthesize taskDescription;
@synthesize happyRating;
@synthesize isTaskComplete;
@synthesize taskDeadline;

-(id)copyWithZone:(NSZone *)zone
{
    WS_JobTask *copiedObject = [[WS_JobTask alloc]init];
    [copiedObject setTaskDescription:[self taskDescription]];
    [copiedObject setHappyRating:[self happyRating]];
    [copiedObject setIsTaskComplete:[self isTaskComplete]];
    [copiedObject setTaskDeadline:[self taskDeadline]];
    return copiedObject;
}

-(NSUInteger)daysUntilDeadline{
    // get a midnight version of ourself:
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd-MM-yyyy"];
	NSDate *currentDate = [[NSDate alloc]init];
	return (int)[self.taskDeadline timeIntervalSinceDate:currentDate] / (60*60*24) *-1;
}
@end

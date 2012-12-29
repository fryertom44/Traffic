//
//  WS_JobTask.m
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_JobTaskAllocation.h"

@implementation WS_JobTaskAllocation

@synthesize taskDescription;
@synthesize happyRating;
@synthesize happyRatingHasChanged;
@synthesize isTaskComplete;
@synthesize taskDeadline;
@synthesize jobTaskAllocationGroupId;
@synthesize jobTaskId;
@synthesize jobId;
@synthesize trafficEmployeeId;
@synthesize totalTimeLoggedMinutes;
@synthesize internalNote;

- (id)init {
    self = [super init];
    if (self) {
        happyRatingHasChanged = FALSE;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    WS_JobTaskAllocation *copiedObject = [[WS_JobTaskAllocation alloc]init];
    [copiedObject setTaskDescription:[self taskDescription]];
    [copiedObject setHappyRating:[self happyRating]];
    [copiedObject setHappyRatingHasChanged:[self happyRatingHasChanged]];
    [copiedObject setIsTaskComplete:[self isTaskComplete]];
    [copiedObject setTaskDeadline:[self taskDeadline]];
    [copiedObject setJobTaskId:[self jobTaskId]];
    [copiedObject setJobId:[self jobId]];
    [copiedObject setTrafficEmployeeId:[self trafficEmployeeId]];
    [copiedObject setTotalTimeLoggedMinutes:[self totalTimeLoggedMinutes]];
    [copiedObject setInternalNote:[self internalNote]];
    return copiedObject;
}

-(NSUInteger)daysUntilDeadline{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd-MM-yyyy"];
	NSDate *currentDate = [[NSDate alloc]init];
	return (int)[self.taskDeadline timeIntervalSinceDate:currentDate] / (60*60*24) *-1;
}

-(NSString*)happyRatingImage{
    if ([self.happyRating isEqualToString:kHappyRatingHappy]) {
        return kHappyRatingHappyImage;
    }else if ([self.happyRating isEqualToString:kHappyRatingSad]){
        return kHappyRatingSadImage;
    }else if ([self.happyRating isEqualToString:kHappyRatingCompleted]){
        return kHappyRatingCompletedImage;
    }
    return kHappyRatingHappyImage;
}

-(void)nextHappyRating{
    if ([self.happyRating isEqualToString:kHappyRatingHappy]) {
        self.happyRating = (NSString*)kHappyRatingSad;
    }else if ([self.happyRating isEqualToString:kHappyRatingSad]){
        self.happyRating = (NSString*)kHappyRatingCompleted;
    }else if ([self.happyRating isEqualToString:kHappyRatingCompleted]){
        self.happyRating = (NSString*)kHappyRatingHappy;
    }
}

@end

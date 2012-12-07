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
@synthesize jobTaskId;
@synthesize trafficEmployeeId;
@synthesize totalTimeLoggedMinutes;

-(id)copyWithZone:(NSZone *)zone
{
    WS_JobTask *copiedObject = [[WS_JobTask alloc]init];
    [copiedObject setTaskDescription:[self taskDescription]];
    [copiedObject setHappyRating:[self happyRating]];
    [copiedObject setIsTaskComplete:[self isTaskComplete]];
    [copiedObject setTaskDeadline:[self taskDeadline]];
    [copiedObject setJobTaskId:[self jobTaskId]];
    [copiedObject setTotalTimeLoggedMinutes:[self totalTimeLoggedMinutes]];
    return copiedObject;
}

-(NSUInteger)daysUntilDeadline{
    // get a midnight version of ourself:
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

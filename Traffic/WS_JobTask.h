//
//  WS_JobTask.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_JobTask : BaseObject
{
    BOOL isTaskComplete;
	NSString* taskDescription;
    NSDate* taskDeadline;
	NSString* happyRating;
    int jobTaskId;
    int trafficEmployeeId;
    int totalTimeLoggedMinutes;
}
@property (nonatomic,retain) NSString* taskDescription;
@property (nonatomic,retain) NSString* happyRating;
@property (nonatomic,retain) NSDate* taskDeadline;
@property (nonatomic) BOOL isTaskComplete;
@property (nonatomic) int jobTaskId;
@property (nonatomic) int trafficEmployeeId;
@property (nonatomic) int totalTimeLoggedMinutes;

-(NSUInteger)daysUntilDeadline;
-(NSString*)happyRatingImage;
-(void)nextHappyRating;

@end

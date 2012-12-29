//
//  WS_JobTask.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_JobTaskAllocation : BaseObject

@property (nonatomic,retain) NSString* taskDescription;
@property (nonatomic,retain) NSString* happyRating;
@property (nonatomic) BOOL happyRatingHasChanged;
@property (nonatomic,retain) NSDate* taskDeadline;
@property (nonatomic) BOOL isTaskComplete;
@property (nonatomic,retain) NSNumber* jobTaskAllocationGroupId;
@property (nonatomic,retain) NSNumber* jobTaskId;
@property (nonatomic,retain) NSNumber* jobId;
@property (nonatomic,retain) NSNumber* trafficEmployeeId;
@property (nonatomic,retain) NSNumber* totalTimeLoggedMinutes;
@property (nonatomic,retain) NSString* internalNote;

-(NSUInteger)daysUntilDeadline;
-(NSString*)happyRatingImage;
-(void)nextHappyRating;

@end

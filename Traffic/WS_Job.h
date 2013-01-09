//
//  WS_Job.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_Job : BaseObject <NSCoding>

@property (nonatomic,retain) NSNumber*jobId;
@property (nonatomic,retain) NSNumber*jobDetailId;
@property (nonatomic,retain) NSDate* jobDeadline;
@property (nonatomic,retain) NSString* jobNumber;
@property (nonatomic,retain) NSArray *jobTasks;

@end

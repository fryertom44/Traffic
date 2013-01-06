//
//  WS_AllocationInterval.h
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_AllocationInterval : BaseObject

@property (nonatomic,retain) NSNumber *allocationIntervalId;
@property (nonatomic,retain) NSNumber *jobTaskTimeAllocationIntervalId;
@property (nonatomic,retain) NSDate *startTime;
@property (nonatomic,retain) NSDate *endTime;
@property (nonatomic,retain) NSString *allocationIntervalStatus;
@property (nonatomic,retain) NSNumber *durationInSeconds;
@property (nonatomic,retain) NSString *uuid;
@property (nonatomic,retain) NSDate *dateModified;
@property (nonatomic,retain) NSString *className;
@end

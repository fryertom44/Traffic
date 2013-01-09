//
//  WS_AllocationInterval.m
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_AllocationInterval.h"

@implementation WS_AllocationInterval

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_AllocationInterval alloc] init];
    if (self != nil)
	{
		self.allocationIntervalId = [coder decodeObjectForKey:@"jobId"];
		self.jobTaskTimeAllocationIntervalId = [coder decodeObjectForKey:@"jobTaskTimeAllocationIntervalId"];
		self.startTime = [coder decodeObjectForKey:@"startTime"];
        self.endTime = [coder decodeObjectForKey:@"endTime"];
        self.allocationIntervalStatus = [coder decodeObjectForKey:@"allocationIntervalStatus"];
        self.durationInSeconds = [coder decodeObjectForKey:@"durationInSeconds"];
		self.uuid = [coder decodeObjectForKey:@"uuid"];
        self.dateModified = [coder decodeObjectForKey:@"dateModified"];
        self.className = [coder decodeObjectForKey:@"className"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.allocationIntervalId forKey:@"allocationIntervalId"];
	[coder encodeObject:self.jobTaskTimeAllocationIntervalId forKey:@"jobTaskTimeAllocationIntervalId"];
	[coder encodeObject:self.startTime forKey:@"startTime"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.allocationIntervalStatus forKey:@"allocationIntervalStatus"];
    [coder encodeObject:self.durationInSeconds forKey:@"durationInSeconds"];
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.dateModified forKey:@"dateModified"];
    [coder encodeObject:self.className forKey:@"className"];
}

@end

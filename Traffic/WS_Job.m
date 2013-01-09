//
//  WS_Job.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_Job.h"

@implementation WS_Job

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_Job alloc] init];
    if (self != nil)
	{
		self.jobId = [coder decodeObjectForKey:@"jobId"];
		self.jobDetailId = [coder decodeObjectForKey:@"jobDetailId"];
		self.jobDeadline = [coder decodeObjectForKey:@"jobDeadline"];
        self.jobNumber = [coder decodeObjectForKey:@"jobNumber"];
        self.jobTasks = [coder decodeObjectForKey:@"jobTasks"];

	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.jobId forKey:@"jobId"];
	[coder encodeObject:self.jobDetailId forKey:@"jobDetailId"];
	[coder encodeObject:self.jobDeadline forKey:@"jobDeadline"];
    [coder encodeObject:self.jobNumber forKey:@"jobNumber"];
    [coder encodeObject:self.jobTasks forKey:@"jobTasks"];

}
@end

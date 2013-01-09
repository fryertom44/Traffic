//
//  WS_JobDetail.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_JobDetail.h"

@implementation WS_JobDetail

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_JobDetail alloc] init];
    if (self != nil)
	{
		self.ownerProjectId = [coder decodeObjectForKey:@"ownerProjectId"];
		self.jobDetailId = [coder decodeObjectForKey:@"jobDetailId"];
		self.jobContactId = [coder decodeObjectForKey:@"jobContactId"];
        self.accountManagerId = [coder decodeObjectForKey:@"accountManagerId"];
        self.jobTitle = [coder decodeObjectForKey:@"jobTitle"];
        self.jobDescription = [coder decodeObjectForKey:@"jobDescription"];
        self.notes = [coder decodeObjectForKey:@"notes"];

	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.ownerProjectId forKey:@"ownerProjectId"];
	[coder encodeObject:self.jobDetailId forKey:@"jobDetailId"];
	[coder encodeObject:self.jobContactId forKey:@"jobContactId"];
    [coder encodeObject:self.accountManagerId forKey:@"accountManagerId"];
    [coder encodeObject:self.jobTitle forKey:@"jobTitle"];
    [coder encodeObject:self.jobDescription forKey:@"jobDescription"];
    [coder encodeObject:self.notes forKey:@"notes"];
}

@end

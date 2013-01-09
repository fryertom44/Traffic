//
//  WS_Project.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_Project.h"

@implementation WS_Project

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_Project alloc] init];
    if (self != nil)
	{
		self.projectId = [coder decodeObjectForKey:@"projectId"];
		self.projectName = [coder decodeObjectForKey:@"projectName"];
		self.clientCRMEntryId = [coder decodeObjectForKey:@"clientCRMEntryId"];        
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.projectName forKey:@"projectName"];
	[coder encodeObject:self.clientCRMEntryId forKey:@"clientCRMEntryId"];
	[coder encodeObject:self.projectId forKey:@"projectId"];    
}

@end

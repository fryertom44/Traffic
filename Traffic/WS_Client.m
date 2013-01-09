//
//  WS_Client.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_Client.h"

@implementation WS_Client

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_Client alloc] init];
    if (self != nil)
	{
		self.clientName = [coder decodeObjectForKey:@"clientName"];
		self.clientId = [coder decodeObjectForKey:@"clientId"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.clientName forKey:@"clientName"];
	[coder encodeObject:self.clientId forKey:@"clientId"];
}

@end

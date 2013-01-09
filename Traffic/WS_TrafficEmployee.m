//
//  WS_StaffMember.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "WS_TrafficEmployee.h"

@implementation WS_TrafficEmployee

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[WS_TrafficEmployee alloc] init];
    if (self != nil)
	{
		self.trafficEmployeeId = [coder decodeObjectForKey:@"trafficEmployeeId"];
		self.firstName = [coder decodeObjectForKey:@"firstName"];
		self.lastName = [coder decodeObjectForKey:@"lastName"];
        self.costPerHour = [coder decodeObjectForKey:@"costPerHour"];        
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.trafficEmployeeId forKey:@"trafficEmployeeId"];
	[coder encodeObject:self.firstName forKey:@"firstName"];
	[coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.costPerHour forKey:@"costPerHour"];
    
}
@end

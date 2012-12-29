//
//  WS_StaffMember.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"
#import "Money.h"

@interface WS_TrafficEmployee : BaseObject

@property (nonatomic,retain) NSNumber *trafficEmployeeId;
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) Money* costPerHour;
@end

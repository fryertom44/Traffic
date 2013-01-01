//
//  GetJobTaskAllocationCommand.h
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AbstractServiceCallCommand.h"

@interface GetJobTaskAllocationCommand : AbstractServiceCallCommand

-(void)executeWithAllocationGroupId:(NSNumber*)allocationGroupId;
@end

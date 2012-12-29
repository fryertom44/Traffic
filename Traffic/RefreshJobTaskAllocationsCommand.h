//
//  RefreshJobTaskAllocationsCommand.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractServiceCallCommand.h"

@interface RefreshJobTaskAllocationsCommand : AbstractServiceCallCommand

- (void)executeWithWindowSize:(int)windowSize;

@end

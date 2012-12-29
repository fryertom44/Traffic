//
//  LoadJobTasksCommand.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractServiceCallCommand.h"

@interface LoadJobTaskAllocationsCommand : AbstractServiceCallCommand

//@property (nonatomic, retain) NSMutableArray *timeEntries;

-(void)executeWithPageNumber:(int)page windowSize:(int)windowSize;

@end

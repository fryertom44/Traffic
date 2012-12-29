//
//  LoginCommand.h
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractServiceCallCommand.h"

@interface LoadTimeEntriesCommand : AbstractServiceCallCommand

@property (nonatomic, retain) NSMutableArray *timeEntries;

-(void)execute;
@end

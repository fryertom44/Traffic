//
//  PutTimesheetCommand.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AbstractServiceCallCommand.h"
#import "DetailViewController.h"

@interface PutTimesheetCommand : AbstractServiceCallCommand

- (void)execute;
@property (nonatomic,retain) id<DetailViewControllerDelegate> delegate;
@end
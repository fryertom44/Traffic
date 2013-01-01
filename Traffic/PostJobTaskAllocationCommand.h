//
//  PostJobTaskAllocationCommand.h
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AbstractServiceCallCommand.h"
#import "DetailViewController.h"

@interface PostJobTaskAllocationCommand : AbstractServiceCallCommand

-(void)execute;
@property (nonatomic)id <DetailViewControllerDelegate> delegate;

@end

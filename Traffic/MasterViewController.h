//
//  MasterViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSMutableData *responseData;
    NSMutableArray *timeEntries;
//    NSMutableArray *_objects;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

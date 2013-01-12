//
//  MasterViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    NSMutableData *responseData;
}
@property (strong, nonatomic) RKPaginator *paginator;
@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)onLoadMoreSelected:(id)sender;

@end

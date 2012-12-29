//
//  SettingsControllerViewController.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *timeIntervalTextInput;

- (IBAction)onFollowTwitterSelected:(id)sender;
- (IBAction)onFollowFacebookSelected:(id)sender;

@end

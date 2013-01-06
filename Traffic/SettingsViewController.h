//
//  SettingsControllerViewController.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *timeIntervalTextInput;
@property (weak, nonatomic) IBOutlet UITextField *maxAllocationResultsTextInput;
@property (nonatomic,retain) UITextField *txtActiveComponent;
@property (weak, nonatomic) IBOutlet UIButton *hideCompletedToggleButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *hideCompletedCell;

- (IBAction)onFollowTwitterSelected:(id)sender;
- (IBAction)onFollowFacebookSelected:(id)sender;
- (IBAction)onHideCompletedToggle:(id)sender;


@end

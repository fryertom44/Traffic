//
//  TaskDetailViewController.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *jobNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskNotesLabel;
@property (weak, nonatomic) IBOutlet UIWebView *briefLabel;

@end

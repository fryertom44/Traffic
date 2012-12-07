//
//  DetailViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WS_TimeEntry.h"
#import "WS_JobTask.h"
#import "PGToggleButton.h"

@class WS_TimeEntry;
@class WS_JobTask;

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) WS_TimeEntry *timesheet;
@property (strong, nonatomic) WS_JobTask *task;
@property (weak, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSDate *timerStartDate;
@property (nonatomic) double timeElapsedInterval;

@property (weak, nonatomic) IBOutlet UILabel *taskDescription;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysRemainingLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *taskProgress;
@property (weak, nonatomic) IBOutlet PGToggleButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UITextView *timesheetTitleInput;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextView *startTimeInput;
@property (weak, nonatomic) IBOutlet UITextView *endTimeInput;
@property (weak, nonatomic) IBOutlet UITextView *durationInput;
@property (weak, nonatomic) IBOutlet UITextView *dateInput;
@property (weak, nonatomic) IBOutlet UITextView *timesheetNotes;
@property (weak, nonatomic) IBOutlet UISwitch *billableSwitch;
@property (weak, nonatomic) IBOutlet UIButton *happyRatingButton;

-(IBAction)changeHappyRating:(id)sender;
-(IBAction)startTimer:(id)sender;
-(IBAction)stopTimer:(id)sender;
@end

//
//  DetailViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WS_TimeEntry.h"
#import "PGToggleButton.h"

@class WS_TimeEntry;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) WS_TimeEntry *detailItem;
//@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) NSTimer *pollingTimer;
@property (strong, nonatomic) NSDate *startDate;

@property (weak, nonatomic) IBOutlet UILabel *timesheetDescription;
@property (weak, nonatomic) IBOutlet UIImageView *happyRating;
@property (weak, nonatomic) IBOutlet UILabel *daysRemainingLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *taskProgress;
@property (weak, nonatomic) IBOutlet PGToggleButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITextView *timesheetNotes;
@property (weak, nonatomic) IBOutlet UISwitch *billableSwitch;

-(IBAction)startTimer:(id)sender;
@end

//
//  DetailViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGToggleButton.h"
#import <RestKit.h>
#import "WS_TimeEntry.h"

@class DetailViewController;

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate>{
    BOOL isObservingTimesheet;
}

@property (weak, nonatomic) IBOutlet UILabel *taskDescription;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysRemainingLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *taskProgress;
@property (weak, nonatomic) IBOutlet PGToggleButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextField *startTimeInput;
@property (weak, nonatomic) IBOutlet UITextField *endTimeInput;
@property (weak, nonatomic) IBOutlet UITextField *durationInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;
@property (weak, nonatomic) IBOutlet UITextView *timesheetNotes;
@property (weak, nonatomic) IBOutlet UISwitch *billableSwitch;
@property (weak, nonatomic) IBOutlet UIButton *happyRatingButton;
@property (nonatomic) id txtActiveComponent;
@property (nonatomic,retain) UIView *subview;

@property (strong, nonatomic) WS_TimeEntry *currentTimesheet;

-(IBAction)changeHappyRating:(id)sender;
-(IBAction)startTimer:(id)sender;
-(IBAction)stopTimer:(id)sender;
-(IBAction)billableValueChanged:(id)sender;
-(IBAction)onSave:(id)sender;
-(IBAction)onCancel:(id)sender;

-(void)handleFailureWithOperation:(RKObjectRequestOperation*)operation error:(NSError*)error;
@end

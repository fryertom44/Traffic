//
//  DetailViewController.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "DetailViewController.h"
#import "WS_TimeEntry.h"
#import "NSDate+Helper.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

const NSInteger kStartTimeTag = 0;
const NSInteger kEndTimeTag = 1;
const NSTimeInterval unitOfTime=1;

@synthesize myTimer;
@synthesize timerStartDate;
@synthesize detailItem = _detailItem;
@synthesize happyRating = _happyRating;
@synthesize startTimeInput = _startTimeInput;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [_detailItem saveState];
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (WS_TimeEntry *)detailItem {
    return _detailItem;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.timesheetDescription.text = self.detailItem.taskDescription;
        if (self.detailItem.endTime != nil) {
            self.daysRemainingLabel.text = [NSDate stringForDisplayFromDate:self.detailItem.endTime];
        } else {
            self.daysRemainingLabel.text = @"0 days remaining";
        }
        [[self happyRating]setImage:[UIImage imageNamed:@"happyRatingHappySmall320.png"]];
//        [[self happyRating]setImage:[UIImage imageNamed:@"happyRatingCompletedSmall320.png"]];
//        [[self happyRating]setImage:[UIImage imageNamed:@"happyRatingSadSmall320.png"]];

        self.billableSwitch.on = self.detailItem.billable;
        self.timerLabel.text = @"00:00:00";
    }
}

- (UIToolbar *)newKeyboardViewWithDoneMethod:(SEL)doneMethod
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleBordered target:self
                                                                    action:@selector(cancelClicked:)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleBordered target:self
                                                                                 action:doneMethod];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,cancelButton,doneButton, nil]];
    return keyboardDoneButtonView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view, typically from a nib.
    [[self recordButton]setImage:[UIImage imageNamed:@"play320.png"] forState:UIControlStateNormal];
    [[self recordButton]setOffStateImage:[UIImage imageNamed:@"play320.png"]];
    [[self recordButton]setOnStateImage:[UIImage imageNamed:@"pause320.png"]];
    [[self stopButton]setImage:[UIImage imageNamed:@"stop320.png"] forState:UIControlStateNormal];
    
    UIDatePicker *timePicker = [[UIDatePicker alloc]init];
    [timePicker setDate:[NSDate date]];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [self.startTimeInput setInputView:timePicker];
    [self.endTimeInput setInputView:timePicker];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.dateInput setInputView:datePicker];
    
    UIDatePicker *durationPicker = [[UIDatePicker alloc]init];
    [durationPicker setDate:[NSDate date]];
    [durationPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [self.durationInput setInputView:durationPicker];
    
    UIToolbar *keyboardStartDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(startTimeDoneClicked:)];
    UIToolbar *keyboardEndTimeDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(endTimeDoneClicked:)];
    UIToolbar *keyboardDurationDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(durationDoneClicked:)];
    UIToolbar *keyboardDateDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(dateDoneClicked:)];

    // Plug the keyboardDoneButtonView into the text field...
    [self.startTimeInput setInputAccessoryView:keyboardStartDoneButtonView];
    [self.endTimeInput setInputAccessoryView:keyboardEndTimeDoneButtonView];
    [self.durationInput setInputAccessoryView:keyboardDurationDoneButtonView];
    [self.dateInput setInputAccessoryView:keyboardDateDoneButtonView];

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"List", @"List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Timer
- (void)updateTimer
{
    if([[self recordButton]isOn])
    {
        self.timeElapsedInterval=self.timeElapsedInterval+unitOfTime;
        [self updateTimerDisplay];
    }
    else{
        //It's paused, so do nothing
    }
}

- (void)updateTimerDisplay
{
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.timeElapsedInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerLabel.text = timeString;
    
}

- (IBAction)startTimer:(id)sender
{
    if(myTimer==nil){
        [self setTimerToZero];
        myTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
}

- (IBAction)stopTimer:(id)sender
{
    [self setTimerToZero];
    [myTimer invalidate];
    myTimer = nil;
    [[self recordButton]setOn:FALSE];
    [self updateTimerDisplay];
}

-(void)setTimerToZero
{
    timerStartDate = [NSDate date];
    self.timeElapsedInterval=[[NSDate date] timeIntervalSinceDate:self.timerStartDate];
}

#pragma mark - date picker
-(void)startTimeDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startTimeInput.inputView;
    self.startTimeInput.text = [NSString stringWithFormat:@"%@",picker.date];
    self.detailItem.startTime = picker.date;
    [[self startTimeInput] resignFirstResponder];
}

-(void)endTimeDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.endTimeInput.inputView;
    self.endTimeInput.text = [NSString stringWithFormat:@"%@",picker.date];
    self.detailItem.endTime = picker.date;
    [[self endTimeInput] resignFirstResponder];
}

-(void)durationDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.durationInput.inputView;
    self.durationInput.text = [NSString stringWithFormat:@"%@",picker.date];
//    self.detailItem.minutes = picker.date);
    [[self durationInput] resignFirstResponder];
}

-(void)dateDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    self.dateInput.text = [NSString stringWithFormat:@"%@",picker.date];
    //    self.detailItem.minutes = picker.date);
    //    self.detailItem.endTime = picker.date;
    [[self dateInput] resignFirstResponder];
}

-(void)cancelClicked:(id)sender
{
    [[self startTimeInput] resignFirstResponder];
}

@end

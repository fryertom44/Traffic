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
#import "Constants.h"

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
@synthesize timesheet = _timesheet;
@synthesize startTimeInput = _startTimeInput;

#pragma mark - Managing the detail item

- (void)setTimesheet:(id)newTimesheet
{
    if (_timesheet != newTimesheet) {
        _timesheet = newTimesheet;
        [_timesheet saveState];
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (WS_TimeEntry *)timesheet {
    return _timesheet;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.timesheet) {
        self.taskDescription.text = self.timesheet.taskDescription;
        self.jobTitle.text = @"Job ID Goes Here";
        [self.happyRatingButton setImage:[UIImage imageNamed:self.timesheet.happyRatingImage] forState:UIControlStateNormal];
        self.timerLabel.text = @"00:00:00";
    }
    
    if(self.task) {
        self.daysRemainingLabel.text = [NSString stringWithFormat:@"%d",self.task.daysUntilDeadline];
        self.timesheetTitleInput.text = self.task.taskDescription;

    }
}

- (UIToolbar *)newKeyboardViewWithDoneMethod:(SEL)doneMethod cancelMethod:(SEL)cancelMethod
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleBordered target:self
                                                                    action:@selector(cancelMethod)];
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
    [[self recordButton]setImage:[UIImage imageNamed:kPlayButtonImage] forState:UIControlStateNormal];
    [[self recordButton]setOffStateImage:[UIImage imageNamed:kPlayButtonImage]];
    [[self recordButton]setOnStateImage:[UIImage imageNamed:kPauseButtonImage]];
    [[self stopButton]setImage:[UIImage imageNamed:kStopButtonImage] forState:UIControlStateNormal];
    
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
    
    UIToolbar *keyboardStartDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(startTimeDoneClicked:)cancelMethod:@selector(startTimeCancelClicked:)];
    UIToolbar *keyboardEndTimeDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(endTimeDoneClicked:)cancelMethod:@selector(endTimeCancelClicked:)];
    UIToolbar *keyboardDurationDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(durationDoneClicked:)cancelMethod:@selector(durationCancelClicked:)];
    UIToolbar *keyboardDateDoneButtonView = (UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(dateDoneClicked:)cancelMethod:@selector(dateCancelClicked:)];

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

- (IBAction)changeHappyRating:(id)sender {
    [self.timesheet nextHappyRating];
    [self.happyRatingButton setImage:[UIImage imageNamed:self.timesheet.happyRatingImage] forState:UIControlStateNormal];
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.startTimeInput.text = [dateFormatter stringFromDate:picker.date];
    [[self startTimeInput] resignFirstResponder];
}

-(void)endTimeDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.endTimeInput.inputView;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.endTimeInput.text = [dateFormatter stringFromDate:picker.date];
    [[self endTimeInput] resignFirstResponder];
}

-(void)durationDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.durationInput.inputView;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:picker.date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    self.durationInput.text = [NSString stringWithFormat:@"%d hour/s %d minute/s",hour,minute];
    [[self durationInput] resignFirstResponder];
}

-(void)dateDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.dateInput.text = [dateFormatter stringFromDate:picker.date];
    [[self dateInput] resignFirstResponder];
}

-(void)startTimeCancelClicked:(id)sender
{
    [self.startTimeInput resignFirstResponder];
}


-(void)endTimeCancelClicked:(id)sender
{
    [self.endTimeInput resignFirstResponder];
}


-(void)durationCancelClicked:(id)sender
{
    [self.durationInput resignFirstResponder];
}


-(void)dateCancelClicked:(id)sender
{
    [self.dateInput resignFirstResponder];
}
@end

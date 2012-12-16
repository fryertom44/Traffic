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
#import "LoadJobCommand.h"
#import "LoadJobDetailCommand.h"

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
@synthesize taskAllocation=_taskAllocation;
@synthesize job=_job;
@synthesize jobDetail=_jobDetail;
@synthesize task=_task;
@synthesize startTimeInput = _startTimeInput;

#pragma mark - Managing the detail item

- (void)setTimesheet:(WS_TimeEntry*)newTimesheet
{
    if (_timesheet != newTimesheet) {
        _timesheet = newTimesheet;
        //[_timesheet saveState];
        
        // Update the view.
        [self displayTimesheetDetails];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setTaskAllocation:(WS_JobTaskAllocation*)newTask
{
    if (_taskAllocation != newTask) {
        _taskAllocation = newTask;
        //[_taskAllocation saveState];
        
        // Update the view.
        [self displayTaskAllocationDetails];
        
        LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
        [loadJobCommand executeAndUpdateComponent:self
                                            jobId:_taskAllocation.jobId
                                        optionalJobTaskId:_taskAllocation.jobTaskId];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


- (void)setJob:(WS_Job*)newJob
{
    if (_job != newJob) {
        _job = newJob;
        //[_job saveState];
        
        // Update the view.
        [self displayJobDetails];
        LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
        [loadJobDetailCommand executeAndUpdateComponent:self
                                            jobDetailId:self.job.jobDetailId];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setTask:(WS_JobTask *)newTask
{
    if (_task != newTask) {
        _task = newTask;
        
        // Update the view.
        [self displayTaskDetails];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setJobDetail:(WS_JobDetail *)jobDetail
{
    if (_jobDetail != jobDetail) {
        _jobDetail = jobDetail;
        
        // Update the view.
        [self displayJobDetailsDetails];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)displayTimesheetDetails
{
    // Update the user interface for the detail item.
    
    if (self.timesheet!=nil) {
        [self.happyRatingButton setImage:[UIImage imageNamed:self.timesheet.happyRatingImage] forState:UIControlStateNormal];
        self.timerLabel.text = @"00:00:00";
    }
}

-(void)displayJobDetails
{
    if(self.job!=nil){
        //Anything to do here?
    }
    
}

-(void)displayJobDetailsDetails
{
    if(self.jobDetail!=nil){
        self.jobTitle.text = [NSString stringWithFormat:@"%@:%@",self.job.jobNumber,self.jobDetail.jobTitle];
    }
}

- (void)displayTaskAllocationDetails
{
    if(self.taskAllocation!=nil) {
        self.daysRemainingLabel.text = [NSString stringWithFormat:@"%d",self.taskAllocation.daysUntilDeadline];
    }
}

- (void)displayTaskDetails
{
    if(self.task!=nil) {
        NSNumber *totalLoggedMinutes = [NSNumber numberWithFloat:self.task.totalTimeLoggedMinutes.floatValue + self.task.totalTimeLoggedBillableMinutes.floatValue];
        float progressAsFloat = totalLoggedMinutes.floatValue / self.task.totalTimeAllocatedMinutes.floatValue;
        [self.taskProgress setProgress:progressAsFloat animated:YES];
        self.progressLabel.text = [NSString stringWithFormat:@"%@ of %@",totalLoggedMinutes,self.task.totalTimeAllocatedMinutes];
        
        if(self.task.jobTaskDescription!=nil)
            self.taskDescription.text = self.task.jobTaskDescription;
    }
}

- (void)configureView
{
    [self displayTimesheetDetails];
    [self displayTaskAllocationDetails];
    [self displayTaskDetails];
    [self displayJobDetails];
    [self displayJobDetailsDetails];
}

- (UIToolbar *)newKeyboardViewWithDoneMethod:(SEL)doneMethod cancelMethod:(SEL)cancelMethod forComponent:(id)component
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
    [timePicker setDatePickerMode:UIDatePickerModeDateAndTime];
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

    // Plug the keyboardDoneButtonView into the text field...
    [self.startTimeInput setInputAccessoryView:(UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(startTimeDoneClicked:)cancelMethod:@selector(startTimeCancelClicked:)forComponent:self.startTimeInput]];
    [self.endTimeInput setInputAccessoryView:(UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(endTimeDoneClicked:)cancelMethod:@selector(endTimeCancelClicked:)forComponent:self.endTimeInput]];
    [self.durationInput setInputAccessoryView:(UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(durationDoneClicked:)cancelMethod:@selector(durationCancelClicked:)forComponent:self.durationInput]];
     [self.dateInput setInputAccessoryView:(UIToolbar *)[self newKeyboardViewWithDoneMethod:@selector(dateDoneClicked:)cancelMethod:@selector(dateCancelClicked:)forComponent:self.dateInput]];

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTaskDetail"]) {
        [[segue destinationViewController] setTimesheet:self.timesheet];
        [[segue destinationViewController] setJob:self.job];
        [[segue destinationViewController] setJobDetail:self.jobDetail];
        [[segue destinationViewController] setTask:self.task];
    }
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

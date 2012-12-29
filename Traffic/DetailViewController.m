//
//  DetailViewController.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "DetailViewController.h"
#import "NSDate+Helper.h"
#import "Constants.h"
#import "GlobalModel.h"
//#import "ParseJobTaskFromJobData.h"
#import "LoadJobCommand.h"
#import "LoadJobDetailCommand.h"
#import "PutTimesheetCommand.h"
#import "UIToolbar+Helper.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

const NSTimeInterval unitOfTime=1;
const NSInteger kSplashScreenTag=999;
UIView *normalView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //store the view for restoring later (when an item is selected)
    normalView = self.view;
    
    if(self.sharedModel.selectedJobTaskAllocation==nil){
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"NothingSelectedView" owner:self options:nil];
        self.view = [xib objectAtIndex:0];
        [self.navigationController setToolbarHidden:TRUE];
    }

	// Do any additional setup after loading the view, typically from a nib.
    [[self recordButton]setImage:[UIImage imageNamed:kPlayButtonImage] forState:UIControlStateNormal];
    [[self recordButton]setOffStateImage:[UIImage imageNamed:kPlayButtonImage]];
    [[self recordButton]setOnStateImage:[UIImage imageNamed:kPauseButtonImage]];
    [[self stopButton]setImage:[UIImage imageNamed:kStopButtonImage] forState:UIControlStateNormal];
    
    UIDatePicker *startPicker = [[UIDatePicker alloc]init];
    [startPicker setDate:[NSDate date]];
    [startPicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    UIDatePicker *endPicker = [[UIDatePicker alloc]init];
    [endPicker setDate:[NSDate date]];
    [endPicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    [self.startTimeInput setInputView:startPicker];
    [self.endTimeInput setInputView:endPicker];

    UIDatePicker *durationPicker = [[UIDatePicker alloc]init];
    [durationPicker setDate:[NSDate date]];
    [durationPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [self.durationInput setInputView:durationPicker];

    // Plug the keyboardDoneButtonView into the text field...
    [self.startTimeInput setInputAccessoryView:[self newKeyboardViewWithDoneMethod:@selector(startTimeDoneClicked:)cancelMethod:@selector(startTimeCancelClicked:)forComponent:self.startTimeInput]];
    [self.endTimeInput setInputAccessoryView:[self newKeyboardViewWithDoneMethod:@selector(endTimeDoneClicked:)cancelMethod:@selector(endTimeCancelClicked:)forComponent:self.endTimeInput]];
    [self.durationInput setInputAccessoryView:[self newKeyboardViewWithDoneMethod:@selector(durationDoneClicked:)cancelMethod:@selector(durationCancelClicked:)forComponent:self.durationInput]];
     [self.dateInput setInputAccessoryView:[self newKeyboardViewWithDoneMethod:@selector(dateDoneClicked:)cancelMethod:@selector(dateCancelClicked:)forComponent:self.dateInput]];

    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobAsData" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJob" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobDetail" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedClient" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTaskAllocation" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTask" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobAsData" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"timesheet" options:NSKeyValueObservingOptionNew context:NULL];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobAsData"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJob"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobDetail"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedClient"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTaskAllocation"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTask"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobAsData"];
    [self.sharedModel removeObserver:self forKeyPath:@"timesheet"];
    
    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"selectedJobAsData"]) {
        
        if(self.sharedModel.timesheet!=nil){
//            self.sharedModel.selectedJobTask = [ParseJobTaskFromJobData parseData:[change objectForKey:NSKeyValueChangeNewKey] fetchJobTaskWithId:self.sharedModel.timesheet.jobTaskId];
        }
        NSLog(@"selectedJobData has been observed!");
    }
    if ([keyPath isEqual:@"selectedJob"]) {
        [self displayJobDetails];
        
        if(self.sharedModel.selectedJob!=nil){
            LoadJobDetailCommand *loadJobDetailCommand = [[LoadJobDetailCommand alloc]init];
            [loadJobDetailCommand executeWithJobDetailId:self.sharedModel.selectedJob.jobDetailId];
        }
        NSLog(@"selectedJob has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobDetail"]) {
        [self displayJobDetailsDetails];
        NSLog(@"selectedJobDetail has been observed!");
    }
    if ([keyPath isEqual:@"selectedClient"]) {
        NSLog(@"selectedClient has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTask"]) {
        [self displayTaskDetails];
        NSLog(@"selectedJobTask has been observed!");
    }
    if ([keyPath isEqual:@"selectedJobTaskAllocation"]) {
        [self displayTaskAllocationDetails];
        
        if(self.sharedModel.selectedJobTaskAllocation!=nil){
            LoadJobCommand *loadJobCommand = [[LoadJobCommand alloc]init];
            [loadJobCommand executeWithJobId:self.sharedModel.selectedJobTaskAllocation.jobId];
        }
        
        self.view = normalView;
        [self.navigationController setToolbarHidden:FALSE animated:TRUE];
        NSLog(@"selectedJobTaskAllocation has been observed!");
    }
    if ([keyPath isEqual:@"timesheet"]) {
        [self displayTimesheetDetails];
        NSLog(@"timesheet has been observed!");
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTaskDetail"]) {
        //Anything to do here?
    }
}

#pragma mark - Managing the detail item

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

- (void)displayTimesheetDetails
{
    // Update the user interface for the detail item.
    
    if (self.sharedModel.timesheet!=nil) {
        self.timerLabel.text = @"00:00:00";
        self.billableSwitch.on = self.sharedModel.timesheet.billable;
    }
}

-(void)displayJobDetails
{
    if(self.sharedModel.selectedJob!=nil){
        //Anything to do here?
    }
    
}

-(void)displayJobDetailsDetails
{
    if(self.sharedModel.selectedJobDetail!=nil){
        self.jobTitle.text = [NSString stringWithFormat:@"%@:%@",self.sharedModel.selectedJob.jobNumber,self.sharedModel.selectedJobDetail.jobTitle];
    }
}

- (void)displayTaskAllocationDetails
{
    if(self.sharedModel.selectedJobTaskAllocation!=nil) {
        [self.happyRatingButton setImage:[UIImage imageNamed:self.sharedModel.selectedJobTaskAllocation.happyRatingImage] forState:UIControlStateNormal];
        self.daysRemainingLabel.text = [NSString stringWithFormat:@"%d",self.sharedModel.selectedJobTaskAllocation.daysUntilDeadline];
    }
}

- (void)displayTaskDetails
{
    if(self.sharedModel.selectedJobTask!=nil) {
        NSNumber *totalLoggedMinutes = [NSNumber numberWithFloat:self.sharedModel.selectedJobTask.totalTimeLoggedMinutes.floatValue + self.sharedModel.selectedJobTask.totalTimeLoggedBillableMinutes.floatValue];
        float progressAsFloat = totalLoggedMinutes.floatValue / self.sharedModel.selectedJobTask.totalTimeAllocatedMinutes.floatValue;
        [self.taskProgress setProgress:progressAsFloat animated:YES];
        self.progressLabel.text = [NSString stringWithFormat:@"%@ of %@",[NSDate timeStringFromMinutes:totalLoggedMinutes.intValue],[NSDate timeStringFromMinutes:self.sharedModel.selectedJobTask.totalTimeAllocatedMinutes.intValue]];
        
        if(self.sharedModel.selectedJobTask.jobTaskDescription!=nil)
            self.taskDescription.text = self.sharedModel.selectedJobTask.jobTaskDescription;
    }
}

- (void)configureView
{
    [self displayTimesheetDetails];
    [self displayTaskAllocationDetails];
    [self displayTaskDetails];
    [self displayJobDetails];
    [self displayJobDetailsDetails];
    [self.navigationController setToolbarHidden:TRUE animated:TRUE];

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
                                                                    action:cancelMethod];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:doneMethod];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,cancelButton,doneButton, nil]];
    return keyboardDoneButtonView;
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
    if([[self recordButton]isOn]){
        self.sharedModel.isRecordingTime = YES;
        self.sharedModel.timeElapsedInterval=self.sharedModel.timeElapsedInterval+unitOfTime;
        [self updateTimerDisplay];
    }else{
        self.sharedModel.isRecordingTime = NO;
    }
}

- (void)updateTimerDisplay
{
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.sharedModel.timeElapsedInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerLabel.text = timeString;
    
}

- (IBAction)goToSettings:(id)sender {
}

- (IBAction)changeHappyRating:(id)sender {
    [self.sharedModel.selectedJobTaskAllocation nextHappyRating];
    [self.happyRatingButton setImage:[UIImage imageNamed:self.sharedModel.selectedJobTaskAllocation.happyRatingImage] forState:UIControlStateNormal];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];
}

- (IBAction)startTimer:(id)sender
{
    if(self.sharedModel.myTimer==nil){
        [self setTimerToZero];
        self.sharedModel.myTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

}

- (IBAction)stopTimer:(id)sender
{
    [self.sharedModel.myTimer invalidate];
    self.sharedModel.myTimer = nil;
    self.sharedModel.isRecordingTime = NO;
    [[self recordButton]setOn:FALSE];
    
    self.startTimeInput.text = [self fullDateStringFromDate:self.sharedModel.timerStartDate];
    self.endTimeInput.text = [self fullDateStringFromDate:[NSDate date]];
    self.durationInput.text = [NSDate timeStringFromMinutes:self.sharedModel.timeElapsedInterval/60];
    [self setMinAndMaxDatesOnPickers];

    [self setTimerToZero];
    [self updateTimerDisplay];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

}

- (IBAction)billableValueChanged:(id)sender {
    if(self.billableSwitch.isOn)
        self.sharedModel.timesheet.billable = TRUE;
    else
        self.sharedModel.timesheet.billable = FALSE;
}

- (IBAction)onSave:(id)sender {
    PutTimesheetCommand *putTimesheetCmd = [[PutTimesheetCommand alloc]init];
    [putTimesheetCmd execute];
}

- (IBAction)onCancel:(id)sender {
    self.sharedModel.timesheet.startTime = nil;
    self.sharedModel.timesheet.endTime = nil;
    self.sharedModel.timesheet.minutes = 0;
    self.sharedModel.timesheet.comment = nil;
    self.sharedModel.timesheet.billable = TRUE;
    [self.sharedModel.selectedJobTaskAllocation restoreState];
    [self configureView];
}

-(void)setTimerToZero
{
    self.sharedModel.timerStartDate = [NSDate date];
    self.sharedModel.timeElapsedInterval=[[NSDate date] timeIntervalSinceDate:self.sharedModel.timerStartDate];
}

#pragma mark - date picker
-(void)startTimeDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startTimeInput.inputView;
    self.startTimeInput.text = [self fullDateStringFromDate:picker.date];
    self.sharedModel.timesheet.startTime = picker.date;
    [self setMinAndMaxDatesOnPickers];
    [[self startTimeInput] resignFirstResponder];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];
}

-(void)endTimeDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.endTimeInput.inputView;
    self.endTimeInput.text = [self fullDateStringFromDate:picker.date];
    self.sharedModel.timesheet.endTime = picker.date;
    [self setMinAndMaxDatesOnPickers];
    [[self endTimeInput] resignFirstResponder];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

}

-(void)setMinAndMaxDatesOnPickers{
    UIDatePicker *startPicker = (UIDatePicker*)self.startTimeInput.inputView;
    UIDatePicker *endPicker = (UIDatePicker*)self.endTimeInput.inputView;
    endPicker.minimumDate = startPicker.date;
    startPicker.maximumDate = endPicker.date;
}

-(void)durationDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.durationInput.inputView;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:picker.date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    self.durationInput.text = [NSString stringWithFormat:@"%02d:%02d",hour,minute];
    self.sharedModel.timesheet.minutes = [NSNumber numberWithInteger:(60*hour+minute)];
    [[self durationInput] resignFirstResponder];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

}

-(void)dateDoneClicked:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    self.dateInput.text = [self fullDateStringFromDate:picker.date];
    [[self dateInput] resignFirstResponder];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

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

-(NSString*)fullDateStringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm"];
    }
    return [dateFormatter stringFromDate:date];
}

@end

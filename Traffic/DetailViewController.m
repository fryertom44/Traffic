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
#import "UIToolbar+Helper.h"
#import "HappyRatingHelper.h"
#import <RestKit.h>

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

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
    [self.startTimeInput setInputView:startPicker];
    
    UIDatePicker *endPicker = [[UIDatePicker alloc]init];
    [endPicker setDate:[NSDate date]];
    [endPicker setDatePickerMode:UIDatePickerModeDateAndTime];    
    [self.endTimeInput setInputView:endPicker];

    UIDatePicker *durationPicker = [[UIDatePicker alloc]init];
    [durationPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [self.durationInput setInputView:durationPicker];
    [self configureInputAccessoryViews];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.sharedModel addObserver:self forKeyPath:@"selectedJob" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobDetail" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedClient" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedProject" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTaskAllocation" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"selectedJobTask" options:NSKeyValueObservingOptionNew context:NULL];
    [self.currentTimesheet addObserver:self forKeyPath:@"timeElapsedInterval" options:NSKeyValueObservingOptionOld context:NULL];
    
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJob"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobDetail"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedClient"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedProject"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTaskAllocation"];
    [self.sharedModel removeObserver:self forKeyPath:@"selectedJobTask"];
    [self.currentTimesheet removeObserver:self forKeyPath:@"timeElapsedInterval"];

    [super viewWillDisappear:animated];
}

-(void)setCurrentTimesheet:(WS_TimeEntry *)currentTimesheet{
    if (_currentTimesheet !=currentTimesheet) {
        if (_currentTimesheet !=nil) {
            [_currentTimesheet removeObserver:self forKeyPath:@"timeElapsedInterval"];
        }
        _currentTimesheet = currentTimesheet;
        [_currentTimesheet addObserver:self forKeyPath:@"timeElapsedInterval" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    //update Timer
    if ([keyPath isEqual:@"timeElapsedInterval"]) {
        [self updateTimerDisplay];
    }
    //selected job changed
    if ([keyPath isEqual:@"selectedJob"]) {
        if (self.sharedModel.selectedJob!=nil) {
            WS_JobDetail *currentJobDetail = [[WS_JobDetail alloc]init];
            currentJobDetail.jobDetailId = self.sharedModel.selectedJob.jobDetailId;
            [[RKObjectManager sharedManager]getObject:currentJobDetail path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedJobDetail = (WS_JobDetail*)[mappingResult firstObject];
                                                  [self.sharedModel.jobDetailsDictionary setObject:self.sharedModel.selectedJobDetail forKey:self.sharedModel.selectedJobDetail.jobDetailId.stringValue];

                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    //selected job detail changed
    if ([keyPath isEqual:@"selectedJobDetail"]) {
        [self displayJobDetailsDetails];
        if (self.sharedModel.selectedJobDetail!=nil) {
            WS_Project *currentProject = [[WS_Project alloc]init];
            currentProject.projectId = self.sharedModel.selectedJobDetail.ownerProjectId;
            [[RKObjectManager sharedManager]getObject:currentProject path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedProject = (WS_Project*)[mappingResult firstObject];
                                                  [self.sharedModel.projectsDictionary setObject:self.sharedModel.selectedProject forKey:self.sharedModel.selectedProject.projectId.stringValue];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
            WS_TrafficEmployee *currentOwner = [[WS_TrafficEmployee alloc]init];
            currentOwner.trafficEmployeeId = self.sharedModel.selectedJobDetail.accountManagerId;
            [[RKObjectManager sharedManager]getObject:currentOwner path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedOwner = (WS_TrafficEmployee*)[mappingResult firstObject];

                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    //selected client changed
    if ([keyPath isEqual:@"selectedClient"]) {
    }
    //selected allocation changed
    if ([keyPath isEqual:@"selectedJobTaskAllocation"]) {
        [self displayTaskAllocationDetails];
        [self displayTimesheetDetails];
        
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        self.currentTimesheet = self.sharedModel.selectedJobTaskAllocation.timesheet;
        
        if(self.sharedModel.selectedJobTaskAllocation!=nil){
            WS_Job *currentJob = [[WS_Job alloc]init];
            currentJob.jobId = self.sharedModel.selectedJobTaskAllocation.jobId;
            [[RKObjectManager sharedManager]getObject:currentJob path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedJob = (WS_Job*)[mappingResult firstObject];
                                                  [self.sharedModel.jobsDictionary setObject:self.sharedModel.selectedJob forKey:self.sharedModel.selectedJob.jobId.stringValue];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
        if (self.view != normalView) {
            [self viewWillDisappear:TRUE];
            self.view = normalView;
            [self viewDidAppear:TRUE];
        }

        [self.navigationController setToolbarHidden:TRUE animated:TRUE];
    }
    if ([keyPath isEqual:@"selectedProject"]) {
        if (self.sharedModel.selectedProject!=nil) {
            WS_Client *currentClient = [[WS_Client alloc]init];
            currentClient.clientId = self.sharedModel.selectedProject.clientCRMEntryId;
            [[RKObjectManager sharedManager]getObject:currentClient path:nil parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.sharedModel.selectedClient = (WS_Client*)[mappingResult firstObject];
                                                  [self.sharedModel.clientsDictionary setObject:self.sharedModel.selectedClient forKey:self.sharedModel.selectedClient.clientId.stringValue];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self handleFailureWithOperation:operation error:error];
                                              }];
        }
    }
    //selected timesheet changed
    if ([keyPath isEqual:@"currentTimesheet"]) {
        [self displayTimesheetDetails];
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
    
    if (self.sharedModel.selectedJobTaskAllocation.timesheet!=nil) {
        [self updateTimerDisplay];
        self.startTimeInput.text = [self fullDateStringFromDate:self.sharedModel.selectedJobTaskAllocation.timesheet.startTime];
        self.startTimeInput.text = [self fullDateStringFromDate:self.sharedModel.selectedJobTaskAllocation.timesheet.startTime];
        self.endTimeInput.text = [self fullDateStringFromDate:self.sharedModel.selectedJobTaskAllocation.timesheet.endTime];
        self.durationInput.text = [NSDate timeStringFromMinutes:self.sharedModel.selectedJobTaskAllocation.timesheet.minutes.intValue];
        self.billableSwitch.on = self.sharedModel.selectedJobTaskAllocation.timesheet.billable.boolValue;
        self.recordButton.on = self.sharedModel.selectedJobTaskAllocation.timesheet.isRecordingTime;
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
        WS_JobTaskAllocation *allocation = self.sharedModel.selectedJobTaskAllocation;
        self.taskDescription.text = allocation.taskDescription;
        [self.happyRatingButton setImage:[HappyRatingHelper happyRatingImageFromString:allocation.happyRating] forState:UIControlStateNormal];
        self.daysRemainingLabel.text = [NSString stringWithFormat:@"%d",allocation.daysUntilDeadline];
        float progressFloat = allocation.totalTimeLoggedMinutes.floatValue / allocation.durationInMinutes.floatValue;
        BOOL taskIsOverWorked = allocation.totalTimeLoggedMinutes.floatValue > allocation.durationInMinutes.floatValue;
        [self.taskProgress setProgressTintColor:(taskIsOverWorked ? [UIColor redColor] : nil)];
        [self.taskProgress setProgress:progressFloat animated:NO];
        self.progressLabel.text = [NSString stringWithFormat:@"%@ of %@",[NSDate timeStringFromMinutes:allocation.totalTimeLoggedMinutes.intValue],[NSDate timeStringFromMinutes:allocation.durationInMinutes.intValue]];
    }
}

- (void)configureView
{
    [self displayTimesheetDetails];
    [self displayTaskAllocationDetails];
    [self displayJobDetailsDetails];
    [self.navigationController setToolbarHidden:TRUE animated:TRUE];
}

- (void)configureInputAccessoryViews
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleBordered target:self
                                                                    action:@selector(inputViewCancelled:)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(inputViewDone:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,cancelButton,doneButton, nil]];
    [self.startTimeInput setInputAccessoryView:keyboardDoneButtonView];
    [self.startTimeInput setDelegate:self];
    [self.endTimeInput setInputAccessoryView:keyboardDoneButtonView];
    [self.endTimeInput setDelegate:self];
    [self.durationInput setInputAccessoryView:keyboardDoneButtonView];
    [self.durationInput setDelegate:self];
    [self.timesheetNotes setInputAccessoryView:keyboardDoneButtonView];
    [self.timesheetNotes setDelegate:self];
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

- (void)updateTimerDisplay
{
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.sharedModel.selectedJobTaskAllocation.timesheet.timeElapsedInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerLabel.text = timeString;
}

- (IBAction)changeHappyRating:(id)sender {
    NSString *currentRating = self.sharedModel.selectedJobTaskAllocation.happyRating;
    NSString *nextHappyRating = [HappyRatingHelper nextHappyRating:currentRating];
    self.sharedModel.selectedJobTaskAllocation.happyRating = nextHappyRating;
    self.sharedModel.selectedJobTaskAllocation.happyRatingWasChanged = [NSNumber numberWithBool:TRUE];
    [self.happyRatingButton setImage:[HappyRatingHelper happyRatingImageFromString:nextHappyRating] forState:UIControlStateNormal];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];
}

- (IBAction)startTimer:(id)sender
{
    if(self.sharedModel.selectedJobTaskAllocation.timesheet.myTimer==nil){
        [self setTimerToZero];
        self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate = [NSDate date];
        self.sharedModel.selectedJobTaskAllocation.timesheet.myTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self.sharedModel.selectedJobTaskAllocation.timesheet selector:@selector(updateTimeElapsed) userInfo:nil repeats:YES];
    }
    self.sharedModel.selectedJobTaskAllocation.timesheet.isRecordingTime = !self.sharedModel.selectedJobTaskAllocation.timesheet.isRecordingTime;
}

- (IBAction)stopTimer:(id)sender
{
    [self.sharedModel.selectedJobTaskAllocation.timesheet.myTimer invalidate];
    self.sharedModel.selectedJobTaskAllocation.timesheet.myTimer = nil;
    self.sharedModel.selectedJobTaskAllocation.timesheet.isRecordingTime = NO;
    [[self recordButton]setOn:FALSE];
    
    NSDate *dateNow = [NSDate date];
//    NSDate *dateAtBeginning = self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate;
//    NSTimeInterval dateAtBeginning = self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate;
    int minutesElapsed = [self regulatedTotalFromMinutes:(self.sharedModel.selectedJobTaskAllocation.timesheet.timeElapsedInterval/60)];
    
//    NSDate *date1 = [[NSDate alloc] init];
    NSDate *timerStartDate = self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate ? self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate : [NSDate date];
    
    self.startTimeInput.text = [self fullDateStringFromDate:timerStartDate];
    self.endTimeInput.text = [self fullDateStringFromDate:dateNow];
    self.durationInput.text = [NSDate timeStringFromMinutes:minutesElapsed];
    
    self.sharedModel.selectedJobTaskAllocation.timesheet.startTime = timerStartDate;
    self.sharedModel.selectedJobTaskAllocation.timesheet.endTime = dateNow;
    self.sharedModel.selectedJobTaskAllocation.timesheet.minutes = [NSNumber numberWithInt:minutesElapsed];
    self.sharedModel.selectedJobTaskAllocation.timesheet.timesheetWasChanged = [NSNumber numberWithBool:TRUE];
    [self setMinAndMaxDatesOnPickers];

    [self setTimerToZero];
    [self updateTimerDisplay];
    [self.navigationController setToolbarHidden:FALSE animated:TRUE];

}

-(void)setTimerToZero
{
    self.sharedModel.selectedJobTaskAllocation.timesheet.timeElapsedInterval = 0;
    self.sharedModel.selectedJobTaskAllocation.timesheet.timerStartDate = nil;
}

#pragma mark - form actions
- (IBAction)billableValueChanged:(id)sender {
    if(self.billableSwitch.isOn)
        self.sharedModel.selectedJobTaskAllocation.timesheet.billable = [NSNumber numberWithBool:TRUE];
    else
        self.sharedModel.selectedJobTaskAllocation.timesheet.billable = [NSNumber numberWithBool:FALSE];
}

- (IBAction)onSave:(id)sender {
    WS_JobTaskAllocation *allocation = self.sharedModel.selectedJobTaskAllocation;
    
    WS_TimeEntry *timesheet = self.sharedModel.selectedJobTaskAllocation.timesheet;
    timesheet.chargeBandId = self.sharedModel.selectedJobTask.chargeBandId;
    timesheet.jobId = self.sharedModel.selectedJobTaskAllocation.jobId;
    timesheet.jobTaskId = self.sharedModel.selectedJobTaskAllocation.jobTaskId;
    timesheet.trafficEmployeeId = self.sharedModel.selectedJobTaskAllocation.trafficEmployeeId;
    timesheet.jobTaskAllocationGroupId = self.sharedModel.selectedJobTaskAllocation.jobTaskAllocationGroupId;
    timesheet.trafficVersion = [NSNumber numberWithInt:-1];
    timesheet.timeEntryId = [NSNumber numberWithInt:-1];
    
    //Hide, but re-show if either one of these calls fails
    [self.navigationController setToolbarHidden:TRUE animated:TRUE];
    
    if(timesheet.timesheetWasChanged && [self isValidTimesheet] && timesheet.isUnsaved){
        [[RKObjectManager sharedManager] putObject:timesheet path:nil parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                               WS_TimeEntry *updatedTimesheet = (WS_TimeEntry*)[mappingResult firstObject];
//                                               self.sharedModel.selectedJobTaskAllocation.timesheet = updatedTimesheet;
//                                               [self displayTimesheetDetails];
                                               timesheet.timesheetWasChanged = FALSE;
                                               if (!allocation.happyRatingWasChanged)
                                                   [self getSelectedAllocationFromServer];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               [self handleFailureWithOperation:operation error:error];
                                               [self.navigationController setToolbarHidden:FALSE animated:TRUE];
                                           }];
        }
//Currently only possible to create new timesheet; should we be able to update an existing one?
    
//  else if(timesheet.timesheetWasChanged && [self isValidTimesheet] && timesheet.trafficVersion.intValue>=0){
//        [[RKObjectManager sharedManager] postObject:timesheet path:nil parameters:nil
//                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                WS_TimeEntry *updatedTimesheet = (WS_TimeEntry*)[mappingResult firstObject];
//                                                self.sharedModel.selectedJobTaskAllocation.timesheet = updatedTimesheet;
//                                                [self displayTimesheetDetails];
//                                                timesheet.timesheetWasChanged = FALSE;

//                                                if (!allocation.happyRatingWasChanged)
//                                                    [self getSelectedAllocationFromServer];
//                                            }
//                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                [self handleFailureWithOperation:operation error:error];
//                                                [self.navigationController setToolbarHidden:FALSE animated:TRUE];
//                                            }];
//    }
    if (allocation.happyRatingWasChanged) {
        NSLog(@"Allocation description: %@", [allocation description]);
        [[RKObjectManager sharedManager] postObject:allocation path:nil parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                WS_JobTaskAllocation *previousJobTaskAllocation = self.sharedModel.selectedJobTaskAllocation;
                                                WS_JobTaskAllocation *updatedJobTaskAllocation = (WS_JobTaskAllocation*)[mappingResult firstObject];
                                                for (int i=0; i < [self.sharedModel.taskAllocations count]; i++) {
                                                    WS_JobTaskAllocation *jta = self.sharedModel.taskAllocations[i];
                                                    if ([jta.jobTaskAllocationGroupId isEqualToNumber:updatedJobTaskAllocation.jobTaskAllocationGroupId]) {
                                                        //keep the timesheet, in case we're recording time
                                                        updatedJobTaskAllocation.timesheet = jta.timesheet;
                                                        [self.sharedModel.taskAllocations setObject:updatedJobTaskAllocation atIndexedSubscript:i];
                                                        break;
                                                    }
                                                }
                                                updatedJobTaskAllocation.happyRatingWasChanged = FALSE;
                                                self.sharedModel.selectedJobTaskAllocation = updatedJobTaskAllocation;
                                                [self displayTaskAllocationDetails];
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                [self handleFailureWithOperation:operation error:error];
                                                [self.navigationController setToolbarHidden:FALSE animated:TRUE];
                                            }];
    }
}

-(void)getSelectedAllocationFromServer{
    WS_JobTaskAllocation *allocation = self.sharedModel.selectedJobTaskAllocation;
    
    [[RKObjectManager sharedManager] getObject:allocation path:nil parameters:nil
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                           WS_JobTaskAllocation *previousJobTaskAllocation = self.sharedModel.selectedJobTaskAllocation;
                                           WS_JobTaskAllocation *updatedJobTaskAllocation = (WS_JobTaskAllocation*)[mappingResult firstObject];
                                           updatedJobTaskAllocation.happyRatingWasChanged = FALSE;
                                           for (int i=0; i < [self.sharedModel.taskAllocations count]; i++) {
                                               WS_JobTaskAllocation *jta = self.sharedModel.taskAllocations[i];
                                               if ([jta.jobTaskAllocationGroupId isEqualToNumber:updatedJobTaskAllocation.jobTaskAllocationGroupId]) {
                                                   //keep the timesheet, in case we're recording time
                                                   updatedJobTaskAllocation.timesheet = jta.timesheet;
                                                   [self.sharedModel.taskAllocations setObject:updatedJobTaskAllocation atIndexedSubscript:i];
                                                   break;
                                               }
                                           }
                                           self.sharedModel.selectedJobTaskAllocation = updatedJobTaskAllocation;
                                           [self displayTaskAllocationDetails];
                                           [self displayTimesheetDetails];
                                       }
                                       failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           [self handleFailureWithOperation:operation error:error];
                                           [self.navigationController setToolbarHidden:FALSE animated:TRUE];
                                       }];
}

- (IBAction)onCancel:(id)sender {
    self.sharedModel.selectedJobTaskAllocation.timesheet.startTime = nil;
    self.sharedModel.selectedJobTaskAllocation.timesheet.endTime = nil;
    self.sharedModel.selectedJobTaskAllocation.timesheet.minutes = 0;
    self.sharedModel.selectedJobTaskAllocation.timesheet.comment = nil;
    self.sharedModel.selectedJobTaskAllocation.timesheet.billable = [NSNumber numberWithBool:TRUE];
//    [self.sharedModel.selectedJobTaskAllocation restoreState];
    [self configureView];
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

#pragma mark - UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.txtActiveComponent = textField;
}

#pragma mark - UITextViewDelegate methods
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.txtActiveComponent = textView;
}

-(void)textViewDidChange:(UITextView *)textView{
    //limit character length to 255    
    NSInteger restrictedLength=255;

    NSString *temp=textView.text;
    
    if([[textView text] length] > restrictedLength){
        textView.text=[temp substringToIndex:restrictedLength];
    }
}

#pragma mark - Input accessory methods
-(void)inputViewDone:(id)sender{
    
    if([self.txtActiveComponent isKindOfClass:[UITextField class]])
    {
        UITextField *activeField = (UITextField*)self.txtActiveComponent;
        UIDatePicker *datePicker = (UIDatePicker*)activeField.inputView;

        if([self.txtActiveComponent isEqual:self.durationInput]){
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:datePicker.date];
            
            NSInteger hour = [components hour];
            NSInteger minute = [components minute];
            int totalMinutes = 60*hour+minute;
            totalMinutes = [self regulatedTotalFromMinutes:totalMinutes];
            
            self.sharedModel.selectedJobTaskAllocation.timesheet.minutes = [NSNumber numberWithInt:totalMinutes];
            self.durationInput.text = [NSDate timeStringFromMinutes:totalMinutes];
            
        }
        else if ([self.txtActiveComponent isEqual:self.startTimeInput]) {
            self.startTimeInput.text = [self fullDateStringFromDate:datePicker.date];
            self.sharedModel.selectedJobTaskAllocation.timesheet.startTime = datePicker.date;
        }
        else if([self.txtActiveComponent isEqual:self.endTimeInput]){
            self.endTimeInput.text = [self fullDateStringFromDate:datePicker.date];
            self.sharedModel.selectedJobTaskAllocation.timesheet.endTime = datePicker.date;
        }
        [self setMinAndMaxDatesOnPickers];
    }

    else if ([self.txtActiveComponent isEqual:self.timesheetNotes]) {
        self.sharedModel.selectedJobTaskAllocation.timesheet.comment = self.timesheetNotes.text;
    }
    [self.txtActiveComponent resignFirstResponder];
    self.txtActiveComponent  = nil;
    self.sharedModel.selectedJobTaskAllocation.timesheet.timesheetWasChanged = [NSNumber numberWithBool:TRUE];
    
    if ([self isValidTimesheet]) {
        [self.navigationController setToolbarHidden:FALSE animated:TRUE];
    }
}

-(BOOL)isValidTimesheet{
    return self.sharedModel.selectedJobTaskAllocation.timesheet
    && self.sharedModel.selectedJobTaskAllocation.timesheet.endTime
    && self.sharedModel.selectedJobTaskAllocation.timesheet.minutes;
}

-(void)inputViewCancelled:(id)sender{
    [self.txtActiveComponent resignFirstResponder];
    self.txtActiveComponent = nil;
}

-(void)setMinAndMaxDatesOnPickers{
    UIDatePicker *startPicker = (UIDatePicker*)self.startTimeInput.inputView;
    UIDatePicker *endPicker = (UIDatePicker*)self.endTimeInput.inputView;
    endPicker.minimumDate = startPicker.date;
    startPicker.maximumDate = endPicker.date;
}

-(int)regulatedTotalFromMinutes:(int)minutes{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int storedInterval = [defaults integerForKey:kTimeIntervalSettingKey];
    
    //Make sure the duration we've selected is divisible by the interval setting (if not, round it up to the next divisible number)
    int leftover = minutes % storedInterval;
    int regulatedTotal = leftover > 0 || minutes < storedInterval ? minutes+(storedInterval-leftover) : minutes;
    return regulatedTotal;
}

-(void)handleFailureWithOperation:(RKObjectRequestOperation*)operation error:(NSError*)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
};

@end

//
//  SettingsControllerViewController.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIToolbar+Helper.h"
#import "ServiceCommandLibrary.h"

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIDatePicker *intervalPicker = [[UIDatePicker alloc]init];
    [intervalPicker setDate:[NSDate date]];
    [intervalPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *storedInterval = (NSNumber*)[defaults objectForKey:kTimeIntervalSettingKey];
    [intervalPicker setMinuteInterval:(NSInteger)storedInterval];
    [self.timeIntervalTextInput setInputView:intervalPicker];
    [self.timeIntervalTextInput setDelegate:self];
    [self.maxAllocationResultsTextInput setDelegate:self];
    [self configureInputAccessoryViews];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *storedInterval = (NSNumber*)[defaults objectForKey:kTimeIntervalSettingKey];
    NSInteger hours = storedInterval.integerValue / 60;
    NSInteger minutes = storedInterval.integerValue % 60;
    self.timeIntervalTextInput.text = [NSString stringWithFormat:@"%02d:%02d",hours,minutes];
    self.maxAllocationResultsTextInput.text = [NSString stringWithFormat:@"%d",[defaults integerForKey:kMaxResultsSettingKey]];
    self.loginAutomaticallySwitch.on = [defaults boolForKey:kLoginAutomaticallySettingKey];
    self.hideCompletedTasksSwitch.on = [defaults boolForKey:kHideCompletedSettingKey];
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.timeIntervalTextInput setInputAccessoryView:keyboardDoneButtonView];
    [self.maxAllocationResultsTextInput setInputAccessoryView:keyboardDoneButtonView];
}

-(void)inputViewDone:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.txtActiveComponent isEqual:self.timeIntervalTextInput]) {
        UIDatePicker* picker = (UIDatePicker*) self.timeIntervalTextInput.inputView;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:picker.date];
        NSInteger minutes = [components minute];
        NSInteger hours = [components hour];
        int totalMinutes = (hours*60)+minutes;
        self.timeIntervalTextInput.text = [NSString stringWithFormat:@"%02d:%02d",hours,minutes];
        [defaults setInteger:totalMinutes forKey:kTimeIntervalSettingKey];
        [self.timeIntervalTextInput resignFirstResponder];
    }

    [defaults synchronize];
    [self.txtActiveComponent resignFirstResponder];
    self.txtActiveComponent = nil;
}

-(void)inputViewCancelled:(id)sender{
    [self.txtActiveComponent resignFirstResponder];
}

#pragma mark - UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.txtActiveComponent = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.txtActiveComponent isEqual:self.maxAllocationResultsTextInput]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:[self.txtActiveComponent.text integerValue] forKey:kMaxResultsSettingKey];
        [defaults synchronize];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.txtActiveComponent isEqual:self.maxAllocationResultsTextInput]){
        /*  limit to only numeric characters  */
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
        
        /*  limit the users input to only 4 characters  */
        NSUInteger newLength = [self.maxAllocationResultsTextInput.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    return YES;
}

#pragma mark - IBActions
- (IBAction)onFollowTwitterSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/TrafficLive"]];
}

- (IBAction)onFollowFacebookSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/sohnartrafficlive"]];
}

- (IBAction)onHideCompletedToggle:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.hideCompletedTasksSwitch.on forKey:kHideCompletedSettingKey];
    [defaults synchronize];
}

- (IBAction)onReloadDataCache:(id)sender {
    NSDictionary *params = @{@"windowSize" : @"5000"};
    [ServiceCommandLibrary loadClientsWithParams:params];
    [ServiceCommandLibrary loadProjectsWithParams:params];
    [ServiceCommandLibrary loadJobsWithParams:params];
    [ServiceCommandLibrary loadJobDetailsWithParams:params];
    [ServiceCommandLibrary loadEmployeesWithParams:params];
}

- (IBAction)onLoginAutomaticallySelected:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.loginAutomaticallySwitch.on forKey:kLoginAutomaticallySettingKey];
    [defaults synchronize];
}

@end

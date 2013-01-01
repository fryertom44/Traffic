//
//  SettingsControllerViewController.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIToolbar+Helper.h"

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
    [self configureInputAccessoryViews];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *storedInterval = (NSNumber*)[defaults objectForKey:kTimeIntervalSettingKey];
    NSInteger hours = storedInterval.integerValue / 60;
    NSInteger minutes = storedInterval.integerValue % 60;
    self.timeIntervalTextInput.text = [NSString stringWithFormat:@"%02d:%02d",hours,minutes];
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
    [self.timeIntervalTextInput setDelegate:self];
}

-(void)inputViewDone:(id)sender{
    UIDatePicker* picker = (UIDatePicker*) self.timeIntervalTextInput.inputView;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:picker.date];
    NSInteger minutes = [components minute];
    NSInteger hours = [components hour];
    int totalMinutes = (hours*60)+minutes;
    self.timeIntervalTextInput.text = [NSString stringWithFormat:@"%02d:%02d",hours,minutes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:totalMinutes forKey:kTimeIntervalSettingKey];
    [defaults synchronize];
    [self.timeIntervalTextInput resignFirstResponder];
}

-(void)inputViewCancelled:(id)sender{
    [self.timeIntervalTextInput resignFirstResponder];
}

- (IBAction)onFollowTwitterSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/TrafficLive"]];
}

- (IBAction)onFollowFacebookSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/sohnartrafficlive"]];
}
@end

//
//  SettingsControllerViewController.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIToolbar+Helper.h"

@interface SettingsViewController ()

@end

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
    [self.timeIntervalTextInput setInputAccessoryView:[UIToolbar newKeyboardViewWithDoneMethod:@selector(timeIntervalDoneClicked:)cancelMethod:@selector(timeIntervalCancelClicked:)forComponent:self.timeIntervalTextInput]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timeIntervalDoneClicked:(id)sender{
    
}

-(void)timeIntervalCancelClicked:(id)sender{
    [self.timeIntervalTextInput resignFirstResponder];
}

- (IBAction)onFollowTwitterSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/TrafficLive"]];
}

- (IBAction)onFollowFacebookSelected:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/sohnartrafficlive"]];
}
@end

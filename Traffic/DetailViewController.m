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

@synthesize pollingTimer;
@synthesize startDate;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.timesheetDescription.text = self.detailItem.taskDescription;
        self.daysRemainingLabel.text = [NSDate stringForDisplayFromDate:self.detailItem.endTime];
        self.billableSwitch.on = self.detailItem.billable;
        [self.startDateButton setTitle:[NSDate stringForDisplayFromDate:self.detailItem.endTime] forState:UIControlStateNormal];
        [self.endDateButton setTitle:[NSDate stringForDisplayFromDate:self.detailItem.endTime] forState:UIControlStateNormal];
        self.timerLabel.text = @"00:00:00";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[self recordButton]setImage:[UIImage imageNamed:@"play320.png"] forState:UIControlStateNormal];
    [[self recordButton]setOffStateImage:[UIImage imageNamed:@"play320.png"]];
    [[self recordButton]setOnStateImage:[UIImage imageNamed:@"pause320.png"]];
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
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerLabel.text = timeString;

}

- (IBAction)startTimer:(id)sender
{
    startDate = [NSDate date];
    // Create the stop watch timer that fires every 10 ms
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                    target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                    repeats:YES];

}

- (IBAction)stopTimer:(id)sender
{
    [pollingTimer invalidate];
    pollingTimer = nil;
    [self updateTimer];
}

@end

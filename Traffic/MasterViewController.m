//
//  MasterViewController.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WS_TimeEntry.h"
#import "WS_JobTaskAllocation.h"
#import "TaskAllocationCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CreateMethods.h"
#import "LoadTimeEntriesCommand.h"
#import "LoadJobTaskAllocationsCommand.h"
#import "RefreshJobTaskAllocationsCommand.h"
#import "GlobalModel.h"
#import "HappyRatingHelper.h"
#import "NSDate+Helper.h"

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    [self loadTaskAllocationsWithPageNumber:self.sharedModel.pageNumber andWindowSize:10];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.sharedModel addObserver:self forKeyPath:@"taskAllocations" options:NSKeyValueObservingOptionNew context:NULL];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
        [self.sharedModel removeObserver:self forKeyPath:@"taskAllocations"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [[self.sharedModel taskAllocations] insertObject:[[WS_JobTaskAllocation alloc] init] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sharedModel taskAllocations]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"Cell";
    
    TaskAllocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TaskAllocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = cell.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    
    [cell setBackgroundView:[[UIView alloc] init]];
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    
    WS_JobTaskAllocation *allocation = self.sharedModel.taskAllocations[indexPath.row];
    cell.companyLabel.text = [NSString stringWithFormat:@"Company Name: <lookup>"];
    cell.jobLabel.text = [NSString stringWithFormat:@"Job ID: %@",allocation.jobId];
    cell.timesheetLabel.text = allocation.taskDescription;
    cell.daysToDeadlineLabel.text = [NSString stringWithFormat:@"%d days %@",allocation.daysUntilDeadlineUnsigned, allocation.daysUntilDeadline < 0 ? @"overdue" : @"remaining"];
    cell.timeCompletedLabel.text = [NSString stringWithFormat:@"%@ of %@", [NSDate timeStringFromMinutes:allocation.totalTimeLoggedMinutes.intValue],[NSDate timeStringFromMinutes:allocation.durationInMinutes.intValue]];
    cell.timeCompletedLabel.textColor = allocation.totalTimeLoggedMinutes.intValue > allocation.durationInMinutes.intValue ? [UIColor redColor] : [UIColor blackColor];
    cell.happyRating.image = [HappyRatingHelper happyRatingImageFromString:allocation.happyRating];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.sharedModel.taskAllocations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS_JobTaskAllocation *taskAllocation = self.sharedModel.taskAllocations[indexPath.row];
    self.sharedModel.selectedJobTaskAllocation = taskAllocation;
    self.sharedModel.timesheet = [self prepareNewTimesheetFromTaskAllocation:taskAllocation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqual:@"taskAllocations"]) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //Do any necessary config here
    }
}

- (WS_TimeEntry*)prepareNewTimesheetFromTaskAllocation:(WS_JobTaskAllocation*)allocation{
    WS_TimeEntry *timesheet = [[WS_TimeEntry alloc]init];
    timesheet.jobTaskId = allocation.jobTaskId;
    timesheet.jobId = allocation.jobId;
    timesheet.trafficEmployeeId = allocation.trafficEmployeeId;
    timesheet.allocationGroupId = allocation.jobTaskAllocationGroupId;
    return timesheet;
}

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

- (void)loadTaskAllocationsWithPageNumber:(int)page andWindowSize:(int)windowSize
{
    LoadJobTaskAllocationsCommand *loadJobTaskAllocationsCommand = [[LoadJobTaskAllocationsCommand alloc]init];
    [loadJobTaskAllocationsCommand executeWithPageNumber:page windowSize:windowSize];
}

- (IBAction)onLoadMoreSelected:(id)sender {
    [self loadTaskAllocationsWithPageNumber:self.sharedModel.pageNumber+1 andWindowSize:10];
}

-(void)refreshList:(id)sender{
    int rowCount = [self.sharedModel.taskAllocations count];
    RefreshJobTaskAllocationsCommand *refreshAllocationsCommand = [[RefreshJobTaskAllocationsCommand alloc]init];
    [refreshAllocationsCommand executeWithWindowSize:rowCount];
}

@end

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
#import "LoadClientCompanies.h"
#import "ServiceCommandLibrary.h"
#import <RestKit/RestKit.h>

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

//    [self loadTaskAllocationsWithPageNumber:self.sharedModel.pageNumber andWindowSize:10];
    
    
    //Setting up...
    NSDictionary *params = @{@"windowSize" : @"5000"};
    [ServiceCommandLibrary loadClientsWithParams:params];
    [ServiceCommandLibrary loadProjectsWithParams:params];
    [ServiceCommandLibrary loadJobsWithParams:params];
    [ServiceCommandLibrary loadJobDetailsWithParams:params];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *allocationParams = [[NSMutableDictionary alloc]initWithDictionary:@{@"currentPage" : [NSNumber numberWithInt:self.sharedModel.pageNumber]}];
    BOOL hideCompleted = [defaults boolForKey:kHideCompletedSettingKey];
    
    if(hideCompleted){
        [allocationParams setObject:@"happyRating|NOT_EQUAL|\"COMPLETE\"" forKey:@"filter"];
    }
    
    NSUInteger windowSize = [defaults integerForKey:kMaxResultsSettingKey];
    windowSize = windowSize ? windowSize : 10;
    [allocationParams setObject:[NSString stringWithFormat:@"%d",windowSize] forKey:@"windowSize"];
    [ServiceCommandLibrary loadJobTaskAllocationsWithParams:allocationParams];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.sharedModel addObserver:self forKeyPath:@"taskAllocations" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"jobDetailsDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"jobsDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"projectsDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"jobTasksDictionary" options:NSKeyValueObservingOptionNew context:NULL];
    [self.sharedModel addObserver:self forKeyPath:@"clientsDictionary" options:NSKeyValueObservingOptionNew context:NULL];

}

-(void)viewDidDisappear:(BOOL)animated{
    [self.sharedModel removeObserver:self forKeyPath:@"taskAllocations"];
    [self.sharedModel removeObserver:self forKeyPath:@"jobDetailsDictionary"];
    [self.sharedModel removeObserver:self forKeyPath:@"jobsDictionary"];
    [self.sharedModel removeObserver:self forKeyPath:@"projectsDictionary"];
    [self.sharedModel removeObserver:self forKeyPath:@"clientsDictionary"];
    [self.sharedModel removeObserver:self forKeyPath:@"jobTasksDictionary"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"taskAllocations"]) {
        [self.refreshControl endRefreshing];
    }
    if ([keyPath isEqual:@"jobDetailsDictionary"]) {
    }
    if ([keyPath isEqual:@"jobsDictionary"]) {
    }
    if ([keyPath isEqual:@"projectsDictionary"]) {
    }
    if ([keyPath isEqual:@"clientsDictionary"]) {
    }
    if ([keyPath isEqual:@"jobTasksDictionary"]) {
    }
    [self refreshListLabels];

}

-(void)refreshListLabels{
    if (self.sharedModel.jobDetailsDictionary
        && self.sharedModel.jobsDictionary
        && self.sharedModel.jobTasksDictionary
        && self.sharedModel.projectsDictionary
        && self.sharedModel.clientsDictionary) {

        [self.tableView reloadData];
    }
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
    WS_JobTask *relatedJobTask = [self.sharedModel.jobTasksDictionary objectForKey:allocation.jobTaskId.stringValue];
    WS_Job *relatedJob = [self.sharedModel.jobsDictionary objectForKey:relatedJobTask.jobId.stringValue];
    WS_JobDetail *relatedJobDetail = [self.sharedModel.jobDetailsDictionary objectForKey:relatedJob.jobDetailId.stringValue];
    WS_Project *relatedProject = [self.sharedModel.projectsDictionary objectForKey:relatedJobDetail.ownerProjectId.stringValue];
    WS_Client *relatedClient = [self.sharedModel.clientsDictionary objectForKey:relatedProject.clientCRMEntryId.stringValue];
    
    cell.companyLabel.text = [NSString stringWithFormat:@"Company Name: %@",relatedClient.clientName];
    cell.jobLabel.text = [NSString stringWithFormat:@"Job: %@-%@",relatedJob.jobNumber, relatedJobDetail.jobTitle];
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
    self.sharedModel.timesheet = [[WS_TimeEntry alloc]init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //Do any necessary config here
    }
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

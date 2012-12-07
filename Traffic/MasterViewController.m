//
//  MasterViewController.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ParserTimeEntry.h"
#import "WS_TimeEntry.h"
#import "WS_JobTask.h"
#import "TimeEntryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CreateMethods.h"
//#import "NSDate+Helper.h"
#import "LoadTimeEntriesCommand.h"
#import "LoadJobTasksCommand.h"
#import "GlobalModel.h"

@implementation MasterViewController

@synthesize timeEntries;
@synthesize allocatedTasks;

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
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
//    LoadTimeEntriesCommand *loadTimeEntriesCommand = [[LoadTimeEntriesCommand alloc]init];
//    [loadTimeEntriesCommand executeAndUpdateComponent:self.tableView];
//    
//    NSLog([NSString stringWithFormat:@"Model time entries: %@",[self timeEntries]]);
    LoadJobTasksCommand *loadJobTasksCommand = [[LoadJobTasksCommand alloc]init];
    [loadJobTasksCommand executeAndUpdateComponent:self.tableView
                                              page:1];
    
    NSLog([NSString stringWithFormat:@"Allocated tasks in model: %@",[self allocatedTasks]]);

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [[self allocatedTasks] insertObject:[[WS_JobTask alloc] init] atIndex:0];
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
    return [[self allocatedTasks]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"Cell";
    
    TimeEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TimeEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = cell.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    
    [cell setBackgroundView:[[UIView alloc] init]];
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    
    GlobalModel* globalModel = [GlobalModel sharedInstance];
    [globalModel printOutTasks];
//    NSLog(@"*DEBUG*%@:%@", @"description", object.taskDescription);
//    NSLog(@"*DEBUG*%@:%@", @"happyRating", object.happyRating);
//    NSLog(@"*DEBUG*%@:%d", @"isTaskComplete", object.isTaskComplete);
    
    WS_JobTask *object = globalModel.allocatedTasks[indexPath.row];
    cell.companyLabel.text = @"Company Name: <lookup>";
    cell.jobLabel.text = @"Job Name: <lookup>";
    cell.timesheetLabel.text = object.taskDescription;
    cell.daysToDeadlineLabel.text = [NSString stringWithFormat:@"%d days remaining",[object daysUntilDeadline]];
    
    if ([@"COMPLETE" isEqualToString:object.happyRating]) {
        cell.happyRating.image = [UIImage imageNamed:@"happyRatingCompletedSmall320.png"];
    }else if ([@"HAPPY" isEqualToString:object.happyRating]){
        cell.happyRating.image = [UIImage imageNamed:@"happyRatingHappySmall320.png"];
    }else{
        cell.happyRating.image = [UIImage imageNamed:@"happyRatingSadSmall320.png"];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [allocatedTasks removeObjectAtIndex:indexPath.row];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        WS_JobTask *object = allocatedTasks[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WS_JobTask *object = allocatedTasks[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (NSMutableArray *)timeEntries {
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    return [sharedModel timeEntries];
}

- (NSMutableArray *)allocatedTasks {
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    return sharedModel.allocatedTasks;
}

@end

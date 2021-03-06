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
#import "GlobalModel.h"
#import "HappyRatingHelper.h"
#import "NSDate+Helper.h"
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

    //Get Big Data from store or load from server
    [self LoadStoredData];
    
    if (!_paginator) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSUInteger windowSize = [defaults integerForKey:kMaxResultsSettingKey];
        BOOL hideCompleted = [defaults boolForKey:kHideCompletedSettingKey];
        
        NSString *requestString = [NSString stringWithFormat:@"/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations?currentPage=:currentPage&windowSize=:perPage",self.sharedModel.loggedInEmployee.trafficEmployeeId];
        
        RKPaginator *paginator = [[RKObjectManager sharedManager] paginatorWithPathPattern:requestString];
        paginator.perPage = windowSize ? windowSize : 10;
        
        [paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            
            if (page == 1) {
                [self.sharedModel.taskAllocations removeAllObjects];
            }
            
            if (!self.sharedModel.taskAllocations) {
                self.sharedModel.taskAllocations = [[NSMutableArray alloc]init];
            }
            for (WS_JobTaskAllocation *allocation in objects) {
                if([allocation isKindOfClass:[WS_JobTaskAllocation class]]){
                    WS_JobTaskAllocation *existingTimeEntry = [self.sharedModel.jobTaskAllocationsDictionary objectForKey:allocation.jobTaskAllocationGroupId.stringValue];
                    if (existingTimeEntry) {
                        allocation.timesheet = existingTimeEntry.timesheet;
                    }
                    
                    if (!hideCompleted || (hideCompleted && ![allocation.happyRating isEqualToString:kHappyRatingCompleted])) {
                        [self.sharedModel.taskAllocations addObject:[self enrichAllocation:allocation]];
                        [self.sharedModel.jobTaskAllocationsDictionary setObject:allocation forKey:allocation.jobTaskAllocationGroupId.stringValue];
                    }
                }
            }
            
            [self.tableView reloadData];
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            [self handleFailureWithOperation:nil error:error];
        }];
        
        self.paginator = paginator;
        [self.tableView reloadData];

        [_paginator loadPage:1];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:FALSE];
    [self.sharedModel addObserver:self forKeyPath:@"isFullyLoaded" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.sharedModel removeObserver:self forKeyPath:@"isFullyLoaded"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"isFullyLoaded"]) {
        for (WS_JobTaskAllocation *allocation in self.sharedModel.taskAllocations) {
            [self enrichAllocation:allocation];
        }
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
    cell.allocation = [self enrichAllocation:allocation];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [[segue destinationViewController] setCurrentTimesheet:self.sharedModel.selectedJobTaskAllocation.timesheet];
    }
}

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

-(WS_JobTaskAllocation*)enrichAllocation:(WS_JobTaskAllocation*)allocation{
    if (!allocation.job && self.sharedModel.jobsDictionary) {
        allocation.job = [self.sharedModel.jobsDictionary objectForKey:allocation.jobId.stringValue];
    }
    if (!allocation.jobDetail && allocation.job && self.sharedModel.jobDetailsDictionary) {
        allocation.jobDetail = [self.sharedModel.jobDetailsDictionary objectForKey:allocation.job.jobDetailId.stringValue];
    }
    if (!allocation.project && allocation.jobDetail && self.sharedModel.projectsDictionary) {
        allocation.project = [self.sharedModel.projectsDictionary objectForKey:allocation.jobDetail.ownerProjectId.stringValue];
    }
    if (!allocation.client && allocation.project && self.sharedModel.clientsDictionary) {
        allocation.client = [self.sharedModel.clientsDictionary objectForKey:allocation.project.clientCRMEntryId.stringValue];
    }
    if (!allocation.employee && allocation.jobDetail && self.sharedModel.employeesDictionary) {
        allocation.employee = [self.sharedModel.employeesDictionary objectForKey:allocation.jobDetail.accountManagerId.stringValue];
    }
    return allocation;
}

- (IBAction)onLoadMoreSelected:(id)sender {
    if (self.paginator) {
        [self.paginator loadNextPage];
    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *allocationParams = [[NSMutableDictionary alloc]initWithDictionary:@{@"currentPage" : [NSNumber numberWithInt:self.sharedModel.pageNumber+1]}];
//    BOOL hideCompleted = [defaults boolForKey:kHideCompletedSettingKey];
//    
//    if(hideCompleted){
//        [allocationParams setObject:@"happyRating|NOT_EQUAL|\"COMPLETE\"" forKey:@"filter"];
//    }
//    
//    NSUInteger windowSize = [defaults integerForKey:kMaxResultsSettingKey];
//    windowSize = windowSize ? windowSize : 10;
//    [allocationParams setObject:[NSString stringWithFormat:@"%d",windowSize] forKey:@"windowSize"];
//    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations",self.sharedModel.loggedInEmployee.trafficEmployeeId]
//                         parameters:allocationParams
//                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                NSArray* jtas = [mappingResult array];
//                                for (WS_JobTaskAllocation *jta in jtas) {
//                                    if ([jta isMemberOfClass:[WS_JobTaskAllocation class]])
//                                        [self.sharedModel.taskAllocations addObject:jta];
//
//                                }
//                                [self.tableView reloadData];
//                            }
//                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                [self handleFailureWithOperation:operation error:error];
//                            }];
}

-(void)refreshList:(id)sender{
    int rowCount = [self.sharedModel.taskAllocations count];
    self.paginator.perPage = rowCount;
    [self.paginator loadPage:1];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *allocationParams = [[NSMutableDictionary alloc]initWithDictionary:@{@"currentPage" : [NSNumber numberWithInt:1]}];
//    BOOL hideCompleted = [defaults boolForKey:kHideCompletedSettingKey];
//    
//    if(hideCompleted){
//        [allocationParams setObject:@"happyRating|NOT_EQUAL|\"COMPLETE\"" forKey:@"filter"];
//    }
//    
//    NSUInteger windowSize = rowCount;
//    windowSize = windowSize ? windowSize : 10;
//    [allocationParams setObject:[NSString stringWithFormat:@"%d",windowSize] forKey:@"windowSize"];
//    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations",self.sharedModel.loggedInEmployee.trafficEmployeeId]
//                         parameters:allocationParams
//                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                NSArray* jtas = [mappingResult array];
//                                NSMutableArray *mutableJtas = [[NSMutableArray alloc]init];
//                                for (WS_JobTaskAllocation *jta in jtas) {
//                                    if ([jta isMemberOfClass:[WS_JobTaskAllocation class]])
//                                    {
//                                        WS_JobTaskAllocation *existingAllocation = [self.sharedModel.jobTaskAllocationsDictionary objectForKey:jta.jobTaskAllocationGroupId.stringValue];
//                                        jta.timesheet = existingAllocation.timesheet;
//                                        [mutableJtas addObject:jta];
//                                    }
//                                
//                                }
//                                self.sharedModel.taskAllocations = mutableJtas;
//                            }
//                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                [self handleFailureWithOperation:operation error:error];
//                            }];
    
    [self.refreshControl endRefreshing];

}


- (void)LoadStoredData
{
    NSDictionary *params = @{@"windowSize" : @"5000"};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Way to clear the store
    [defaults removeObjectForKey:kClientsStoreKey];
    [defaults removeObjectForKey:kProjectsStoreKey];
    [defaults removeObjectForKey:kJobDetailsStoreKey];
    [defaults removeObjectForKey:kJobsStoreKey];
    [defaults removeObjectForKey:kEmployeesStoreKey];
    [defaults synchronize];
    
    NSData *storedClientData = [defaults objectForKey:kClientsStoreKey];
    
    if(!storedClientData)
        [ServiceCommandLibrary loadClientsWithParams:params];
    else{
        self.sharedModel.clients = [NSKeyedUnarchiver unarchiveObjectWithData:storedClientData];
        NSLog(@"Unarchived Clients: %@", [self.sharedModel.clients description]);
    }
    
    NSData *storedProjectsData = [defaults objectForKey:kProjectsStoreKey];
    if(!storedProjectsData)
        [ServiceCommandLibrary loadProjectsWithParams:params];
    else{
        self.sharedModel.projects = [NSKeyedUnarchiver unarchiveObjectWithData:storedProjectsData];
        NSLog(@"Unarchived Projects: %@", [self.sharedModel.projects description]);
    }
    
    NSData *storedJobsData = [defaults objectForKey:kJobsStoreKey];
    if(!storedJobsData)
        [ServiceCommandLibrary loadJobsWithParams:params];
    else{
        self.sharedModel.jobs = [NSKeyedUnarchiver unarchiveObjectWithData:storedJobsData];
        NSLog(@"Unarchived Jobs: %@", [self.sharedModel.jobs description]);
    }
    
    NSData *storedJobDetailsData = [defaults objectForKey:kJobDetailsStoreKey];
    if(!storedJobDetailsData)
        [ServiceCommandLibrary loadJobDetailsWithParams:params];
    else{
        self.sharedModel.jobDetails = [NSKeyedUnarchiver unarchiveObjectWithData:storedJobDetailsData];
        NSLog(@"Unarchived Job Details: %@", [self.sharedModel.jobDetails description]);
    }
    
    NSData *storedEmployeesData = [defaults objectForKey:kEmployeesStoreKey];
    if(!storedEmployeesData)
        [ServiceCommandLibrary loadEmployeesWithParams:params];
    else{
        self.sharedModel.employees = [NSKeyedUnarchiver unarchiveObjectWithData:storedEmployeesData];
        NSLog(@"Unarchived Employees: %@", [self.sharedModel.employees description]);
    }
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

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

@end

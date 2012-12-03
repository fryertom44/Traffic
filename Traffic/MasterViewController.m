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
#import "TimeEntryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CreateMethods.h"
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
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self loadTimeEntries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!timeEntries) {
        timeEntries = [[NSMutableArray alloc] init];
    }
    [timeEntries insertObject:[[WS_TimeEntry alloc] init] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)loadTimeEntries {
    
	responseData = [NSMutableData data];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeentries?startDate=1970-01-01&endDate=3000-01-01"]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - Connect to web service & Load Time Entries

// NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"fryertom@gmail.com"
                                                                    password:@"MR6gFeqG585J5SVZ7Lnv128wHhT2EBgjl5C7F2i2"
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSLog(@"DONE. Received Bytes: %d", [responseData length]);
	NSString *theJSON = [[NSString alloc]
						 initWithBytes: [responseData mutableBytes]
						 length:[responseData length]
						 encoding:NSUTF8StringEncoding];
	//---shows the JSON ---
	NSLog(@"%@", theJSON);
	
	//Initialize the delegate.
//	ParserTimeEntry *timeEntriesParser = [[ParserTimeEntry alloc] initParser];
	
	//Start parsing the XML file.
//	timeEntries = [timeEntriesParser parseData:responseData];
    
    
//    NSMutableArray *timeEntries = [[NSMutableArray alloc] init];
    
    NSDictionary* json = nil;
    if (responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:nil];
    }
    
    for (id key in json) {
        NSLog(@"key: %@, value: %@", key, [json objectForKey:key]);
    }
    
	NSArray *jsonObjects = [json objectForKey:@"resultList"];
	
    if (!timeEntries) {
        timeEntries = [[NSMutableArray alloc] init];
    }

	for (NSDictionary *dict in jsonObjects)
	{
		WS_TimeEntry *timeEntry = [[WS_TimeEntry alloc] init];
		[timeEntry setTimeEntryId:[[dict valueForKey:@"id"] intValue]];
		[timeEntry setJobId:[[dict valueForKeyPath:@"jobId.id"]intValue]];
		[timeEntry setJobTaskId:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]];
		[timeEntry setLockedByApproval:[dict objectForKey:@"lockedByApproval"]];
		[timeEntry setMinutes:[[dict objectForKey:@"minutes"]intValue]];
		[timeEntry setTaskDescription:[NSMutableString stringWithString:[dict objectForKey:@"taskDescription"]]];
		[timeEntry setAllocationGroupId:[[dict valueForKeyPath:@"allocationGroupId.id"]intValue]];
		//[timeEntry setTaskRate:[dict objectForKey:@"taskRate"]];
		//[timeEntry setTimeEntryCost:[dict objectForKey:@"timeEntryCost"]];
		[timeEntry setTrafficEmployeeId:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]];
		[timeEntry setBillable:[[dict objectForKey:@"billable"]boolValue]];
		[timeEntry setVersion:[[dict objectForKey:@"version"]intValue]];
		[timeEntry setChargebandId:[[dict valueForKeyPath:@"chargebandId.id"]intValue]];
		[timeEntry setComment:[dict objectForKey:@"comment"]];
		[timeEntry setExported:[[dict objectForKey:@"exported"]boolValue]];
        NSString *dateString = [dict objectForKey:@"endTime"];
        NSDate *endTimeAsDate = [NSDate dateFromString:dateString];
		[timeEntry setEndTime:endTimeAsDate];
		[timeEntry setValueOfTimeEntry:[dict objectForKey:@"valueOfTimeEntry"]];
//		NSLog(@"%@:%@", @"id", [dict valueForKeyPath:@"id"]);
//		NSLog(@"%@:%@", @"jobId.id", [dict valueForKeyPath:@"jobId.id"]);
//		NSLog(@"%@:%@", @"jobTaskId.id", [dict valueForKeyPath:@"jobTaskId.id"]);
//		NSLog(@"%@:%@", @"lockedByApproval", [dict valueForKey:@"lockedByApproval"]);
//		NSLog(@"%@:%@", @"minutes", [dict valueForKey:@"minutes"]);
//		NSLog(@"%@:%@", @"taskDescription", [dict valueForKey:@"taskDescription"]);
//		NSLog(@"%@:%@", @"allocationGroupId.id", [dict valueForKeyPath:@"allocationGroupId.id"]);
//		NSLog(@"%@:%@", @"taskRate", [dict valueForKey:@"taskRate"]);
//		NSLog(@"%@:%@", @"timeEntryCost", [dict valueForKey:@"timeEntryCost"]);
//		NSLog(@"%@:%@", @"trafficEmployeeId.id", [dict valueForKey:@"trafficEmployeeId.id"]);
//		NSLog(@"%@:%@", @"billable", [dict valueForKey:@"billable"]);
//		NSLog(@"%@:%@", @"version", [dict valueForKey:@"version"]);
//		NSLog(@"%@:%@", @"chargebandId.id", [dict valueForKey:@"chargebandId.id"]);
//		NSLog(@"%@:%@", @"comment", [dict valueForKey:@"comment"]);
//		NSLog(@"%@:%@", @"exported", [dict valueForKey:@"exported"]);
//		NSLog(@"%@:%@", @"endTime", [dict valueForKey:@"endTime"]);
//		NSLog(@"%@:%@", @"valueOfTimeEntry", [dict valueForKey:@"valueOfTimeEntry"]);
//        NSLog(@"Printing my dictionary out by enumerating:");
//        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSLog(@"\tKey: %@ Value: %@", key, obj);
//        }];

		[timeEntries addObject:timeEntry];
	}    
    
	if(timeEntries)
		NSLog(@"No Errors");
	else
		NSLog(@"Error - no time entries were found");
	
    	[self.tableView reloadData];
    //	[responseData release];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
    //	[responseData release];
    //	[connection release];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timeEntries.count;
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
        
    WS_TimeEntry *object = timeEntries[indexPath.row];
    cell.companyLabel.text = @"Company must be looked up";
    cell.jobLabel.text = @"Job must be looked up";
    cell.timesheetLabel.text = [object taskDescription];
    cell.daysToDeadlineLabel.text = [[object endTime]description];
    cell.happyRating.image = [UIImage imageNamed:@"happyRatingHappySmall320.png"];
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
        [timeEntries removeObjectAtIndex:indexPath.row];
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
        WS_TimeEntry *object = timeEntries[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WS_TimeEntry *object = timeEntries[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end

//
//  LoadTimeEntriesCommand.m
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadTimeEntriesCommand.h"
#import "ParserTimeEntry.h"
#import "NSDate+Helper.h"
#import "NSDictionary+Helper.h"

@implementation LoadTimeEntriesCommand

- (void)execute{
    
	super.responseData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeentries?startDate=2010-01-01&endDate=2015-01-01"]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];

}

#pragma mark - NSURLConnection Delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
	NSString *theJSON = [[NSString alloc]
						 initWithBytes: [super.responseData mutableBytes]
						 length:[super.responseData length]
						 encoding:NSUTF8StringEncoding];
	//---shows the JSON ---
	NSLog(@"%@", theJSON);
	
    NSDictionary* json = nil;
    if (super.responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
    }
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSMutableArray *timeEntries = [[NSMutableArray alloc]init];
	NSArray *jsonObjects = [json objectForKey:@"resultList"];
	
	for (NSDictionary *dict in jsonObjects)
	{
        WS_TimeEntry *timeEntry = [[WS_TimeEntry alloc] init];
        [timeEntry setTimeEntryId:[NSNumber numberWithInt:[[dict valueForKey:@"id"] intValue]]];
        [timeEntry setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
        [timeEntry setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
        [timeEntry setLockedByApproval:[dict objectForKey:@"lockedByApproval"]];
        [timeEntry setMinutes:[NSNumber numberWithInt:[[dict objectForKey:@"minutes"]intValue]]];
        [timeEntry setTaskDescription:[NSMutableString stringWithString:[dict objectForKey:@"taskDescription"]]];
        [timeEntry setAllocationGroupId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"allocationGroupId.id"]intValue]]];
        [timeEntry setTaskRate:[super newMoneyFromDict:[dict objectForKey:@"taskRate"]]];
        [timeEntry setTimeEntryCost:[super newMoneyFromDict:[dict objectForKey:@"timeEntryCost"]]];
        [timeEntry setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
        [timeEntry setBillable:[[dict objectForKey:@"billable"]boolValue]];
        [timeEntry setVersion:[NSNumber numberWithInt:[[dict objectForKey:@"version"]intValue]]];
        [timeEntry setChargebandId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"chargebandId.id"]intValue]]];
        [timeEntry setComment:[dict objectForKey:@"comment"]];
        [timeEntry setExported:[[dict objectForKey:@"exported"]boolValue]];
        [timeEntry setEndTime:[NSDate dateFromString:[dict objectForKey:@"endTime"]]];
        [timeEntry setValueOfTimeEntry:[super newMoneyFromDict:[dict objectForKey:@"valueOfTimeEntry"]]];
//    NSLog(@"%@:%@", @"id", [dict valueForKeyPath:@"id"]);
//    NSLog(@"%@:%@", @"jobId.id", [dict valueForKeyPath:@"jobId.id"]);
//    NSLog(@"%@:%@", @"jobTaskId.id", [dict valueForKeyPath:@"jobTaskId.id"]);
//    NSLog(@"%@:%@", @"lockedByApproval", [dict valueForKey:@"lockedByApproval"]);
//    NSLog(@"%@:%@", @"minutes", [dict valueForKey:@"minutes"]);
//    NSLog(@"%@:%@", @"taskDescription", [dict valueForKey:@"taskDescription"]);
//    NSLog(@"%@:%@", @"allocationGroupId.id", [dict valueForKeyPath:@"allocationGroupId.id"]);
//    NSLog(@"%@:%@", @"taskRate", [dict valueForKey:@"taskRate"]);
//    NSLog(@"%@:%@", @"timeEntryCost", [dict valueForKey:@"timeEntryCost"]);
//    NSLog(@"%@:%@", @"trafficEmployeeId.id", [dict valueForKey:@"trafficEmployeeId.id"]);
//    NSLog(@"%@:%@", @"billable", [dict valueForKey:@"billable"]);
//    NSLog(@"%@:%@", @"version", [dict valueForKey:@"version"]);
//    NSLog(@"%@:%@", @"chargebandId.id", [dict valueForKey:@"chargebandId.id"]);
//    NSLog(@"%@:%@", @"comment", [dict valueForKey:@"comment"]);
//    NSLog(@"%@:%@", @"exported", [dict valueForKey:@"exported"]);
//    NSLog(@"%@:%@", @"endTime", [dict valueForKey:@"endTime"]);
//    NSLog(@"%@:%@", @"valueOfTimeEntry", [dict valueForKey:@"valueOfTimeEntry"]);
    
    [timeEntries addObject:timeEntry];
    }
    self.sharedModel.timeEntries = timeEntries;

}

@end

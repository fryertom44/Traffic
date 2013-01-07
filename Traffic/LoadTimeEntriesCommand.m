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
#import "NSDictionary+Helpers.h"

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
    
//	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
//	NSString *theJSON = [[NSString alloc]
//						 initWithBytes: [super.responseData mutableBytes]
//						 length:[super.responseData length]
//						 encoding:NSUTF8StringEncoding];
//	//---shows the JSON ---
//	NSLog(@"%@", theJSON);
	
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
        [timeEntry setTaskDescription:[dict stringForKey:@"taskDescription"]];
        [timeEntry setJobTaskAllocationGroupId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"allocationGroupId.id"]intValue]]];
        [timeEntry setTaskRate:[super newMoneyFromDict:[dict objectForKey:@"taskRate"]]];
        [timeEntry setTimeEntryCost:[super newMoneyFromDict:[dict objectForKey:@"timeEntryCost"]]];
        [timeEntry setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
        [timeEntry setBillable:[dict objectForKey:@"billable"]];
        [timeEntry setTrafficVersion:[NSNumber numberWithInt:[[dict objectForKey:@"version"]intValue]]];
        [timeEntry setChargeBandId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"chargebandId.id"]intValue]]];
        [timeEntry setComment:[dict stringForKey:@"comment"]];
        [timeEntry setExported:[dict objectForKey:@"exported"]];
        [timeEntry setEndTime:[NSDate dateFromString:[dict objectForKey:@"endTime"]]];
        [timeEntry setValueOfTimeEntry:[super newMoneyFromDict:[dict objectForKey:@"valueOfTimeEntry"]]];
        [timeEntry setTrafficVersion:[NSNumber numberWithInteger:[dict integerForKey:@"version"]]];
    
    [timeEntries addObject:timeEntry];
    }
    self.sharedModel.timeEntries = timeEntries;

}

@end

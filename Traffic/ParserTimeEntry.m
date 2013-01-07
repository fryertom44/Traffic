//
//  ParserTimeEntry.m
//  traffic
//
//  Created by Tom Fryer on 15/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ParserTimeEntry.h"
#import "WS_TimeEntry.h"
#import "NSDate+Helper.h"
#import "GlobalModel.h"

@implementation ParserTimeEntry

+(void)parseData:(NSData *)data{
    NSMutableArray *timeEntries = [[NSMutableArray alloc] init];
    NSDictionary* json = nil;
    if (data) {
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
    }

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
		[timeEntry setJobTaskAllocationGroupId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"allocationGroupId.id"]intValue]]];
		//[timeEntry setTaskRate:[dict objectForKey:@"taskRate"]];
		//[timeEntry setTimeEntryCost:[dict objectForKey:@"timeEntryCost"]];]
		[timeEntry setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
		[timeEntry setBillable:[dict objectForKey:@"billable"]];
		[timeEntry setTrafficVersion:[NSNumber numberWithInt:[[dict objectForKey:@"version"]intValue]]];
		[timeEntry setChargeBandId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"chargeBandId.id"]intValue]]];
		[timeEntry setComment:[dict objectForKey:@"comment"]];
		[timeEntry setExported:[dict objectForKey:@"exported"]];
//        NSString *dateString = [dict objectForKey:@"endTime"];
//        NSDate *endTimeAsDate = [NSDate dateFromString:[dict objectForKey:@"endTime"]];
		[timeEntry setEndTime:[NSDate dateFromString:[dict objectForKey:@"endTime"]]];
		[timeEntry setValueOfTimeEntry:[dict objectForKey:@"valueOfTimeEntry"]];
		NSLog(@"%@:%@", @"id", [dict valueForKeyPath:@"id"]);
		NSLog(@"%@:%@", @"jobId.id", [dict valueForKeyPath:@"jobId.id"]);
		NSLog(@"%@:%@", @"jobTaskId.id", [dict valueForKeyPath:@"jobTaskId.id"]);
		NSLog(@"%@:%@", @"lockedByApproval", [dict valueForKey:@"lockedByApproval"]);
		NSLog(@"%@:%@", @"minutes", [dict valueForKey:@"minutes"]);
		NSLog(@"%@:%@", @"taskDescription", [dict valueForKey:@"taskDescription"]);
		NSLog(@"%@:%@", @"allocationGroupId.id", [dict valueForKeyPath:@"allocationGroupId.id"]);
		NSLog(@"%@:%@", @"taskRate", [dict valueForKey:@"taskRate"]);
		NSLog(@"%@:%@", @"timeEntryCost", [dict valueForKey:@"timeEntryCost"]);
		NSLog(@"%@:%@", @"trafficEmployeeId.id", [dict valueForKey:@"trafficEmployeeId.id"]);
		NSLog(@"%@:%@", @"billable", [dict valueForKey:@"billable"]);
		NSLog(@"%@:%@", @"version", [dict valueForKey:@"version"]);
		NSLog(@"%@:%@", @"chargebandId.id", [dict valueForKey:@"chargebandId.id"]);
		NSLog(@"%@:%@", @"comment", [dict valueForKey:@"comment"]);
		NSLog(@"%@:%@", @"exported", [dict valueForKey:@"exported"]);
		NSLog(@"%@:%@", @"endTime", [dict valueForKey:@"endTime"]);
		NSLog(@"%@:%@", @"valueOfTimeEntry", [dict valueForKey:@"valueOfTimeEntry"]);
        
		[timeEntries addObject:timeEntry];
	}
    GlobalModel *globalModel = [GlobalModel sharedInstance];
    globalModel.timeEntries = timeEntries;
}


@end

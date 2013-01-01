//
//  PutTimesheetCommand.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "PutTimesheetCommand.h"
#import "NSDate+Helper.h"
#import "NSDictionary+Helpers.h"

@implementation PutTimesheetCommand

- (void)execute{
	super.responseData = [NSMutableData data];
    WS_TimeEntry *timesheet = self.sharedModel.timesheet;
    WS_JobTaskAllocation *allocation = self.sharedModel.selectedJobTaskAllocation;
    WS_JobTask *task = self.sharedModel.selectedJobTask;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSDictionary dictionaryWithObjectsAndKeys:task.jobId,@"id",nil],@"jobId",
                                    [NSDictionary dictionaryWithObjectsAndKeys:allocation.jobTaskAllocationGroupId,@"id",nil],@"allocationGroupId",
                                    [NSNull null],@"jobStageDescription",
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currencyType",[NSNumber numberWithInt:0],@"amountString",nil],@"timeEntryCost",
//                                    [NSNull null],@"timeEntryCost",
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currencyType",[NSNumber numberWithInt:0],@"amountString",nil],@"timeEntryPersonalRate",
//                                    [NSNull null],@"timeEntryPersonalRate",
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currencyType",[NSNumber numberWithInt:0],@"amountString",nil],@"valueOfTimeEntry",
//                                    [NSNull null],@"valueOfTimeEntry",
                                    [NSNumber numberWithBool:timesheet.exported], @"exported",
                                    [NSNumber numberWithBool:timesheet.lockedByApproval], @"lockedByApproval",
                                    [df stringFromDate:timesheet.endTime],@"endTime",
                                    [NSNull null],@"workPoints",
                                    timesheet.version.stringValue, @"version",
                                    [NSNumber numberWithBool:timesheet.billable], @"billable",
                                    [df stringFromDate:timesheet.startTime], @"startTime",
                                    timesheet.timeEntryId.stringValue, @"id",
                                    [NSDictionary dictionaryWithObjectsAndKeys:timesheet.jobTaskId,@"id",nil],@"jobTaskId",
                                    [NSDictionary dictionaryWithObjectsAndKeys:timesheet.trafficEmployeeId,@"id",nil],@"trafficEmployeeId",
                                    timesheet.taskDescription,@"taskDescription",
                                    [NSDictionary dictionaryWithObjectsAndKeys:timesheet.chargebandId,@"id",nil],@"chargeBandId",
                                    timesheet.minutes,@"minutes",
                                    [NSNull null],@"lockedByApprovalEmployeeId",
                                    [NSNull null],@"exportError",
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currencyType",[NSNumber numberWithInt:0],@"amountString",nil],@"taskRate",
//                                    [NSNull null],@"taskRate",
                                    [NSNull null],@"taskComplete",
                                    [NSNull null],@"lockedByApprovalDate",
                                    timesheet.comment,@"comment",
                                    nil];
    
    NSLog(@"PUT TIMESHEET: %@",[jsonDictionary description]);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON as string: %@", jsonString);
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeentries"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
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
    
    NSDictionary* dict = nil;
    if (super.responseData) {
        dict = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
    }
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];

    WS_TimeEntry *timeEntry = [[WS_TimeEntry alloc] init];
    [timeEntry setTimeEntryId:[NSNumber numberWithInt:[[dict valueForKey:@"id"] intValue]]];
    if([timeEntry.timeEntryId isEqualToNumber:[NSNumber numberWithInt:0]] ){
        return;
    }
    [timeEntry setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
    [timeEntry setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
    [timeEntry setLockedByApproval:[dict objectForKey:@"lockedByApproval"]];
    [timeEntry setMinutes:[NSNumber numberWithInt:[[dict objectForKey:@"minutes"]intValue]]];
    [timeEntry setTaskDescription:[dict stringForKey:@"taskDescription"]];
    [timeEntry setAllocationGroupId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"allocationGroupId.id"]intValue]]];
    [timeEntry setTaskRate:[super newMoneyFromDict:[dict objectForKey:@"taskRate"]]];
    [timeEntry setTimeEntryCost:[super newMoneyFromDict:[dict objectForKey:@"timeEntryCost"]]];
    [timeEntry setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
    [timeEntry setBillable:[[dict objectForKey:@"billable"]boolValue]];
    [timeEntry setVersion:[NSNumber numberWithInt:[[dict objectForKey:@"version"]intValue]]];
    [timeEntry setChargebandId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"chargebandId.id"]intValue]]];
    [timeEntry setComment:[dict stringForKey:@"comment"]];
    [timeEntry setExported:[[dict objectForKey:@"exported"]boolValue]];
    [timeEntry setEndTime:[NSDate dateFromString:[dict objectForKey:@"endTime"]]];
    [timeEntry setValueOfTimeEntry:[super newMoneyFromDict:[dict objectForKey:@"valueOfTimeEntry"]]];
    
    self.sharedModel.timesheet = timeEntry;
    
    if(self.delegate){
        [self.delegate saveSuccessful];
    }
}

@end

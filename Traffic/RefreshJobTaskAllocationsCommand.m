//
//  RefreshJobTaskAllocationsCommand.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "RefreshJobTaskAllocationsCommand.h"
#import "ParserJobTaskAllocation.h"
#import "WS_AllocationInterval.h"
#import "NSNull+Addition.h"
#import "NSDictionary+Helpers.h"

@implementation RefreshJobTaskAllocationsCommand

- (void)executeWithWindowSize:(int)windowSize{
	super.responseData = [NSMutableData data];
    if(!windowSize){
        windowSize=5;
    }
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations?currentPage=%d&windowSize=%d",super.sharedModel.loggedInEmployee.trafficEmployeeId,1,windowSize];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
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
    NSDictionary* dict = nil;
    if (super.responseData) {
        dict = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
        
        self.sharedModel.taskAllocations = [self parseData:super.responseData];
    }
	if(self.sharedModel.taskAllocations)
        NSLog(@"No Errors");
    else
		NSLog(@"Error - there are no job tasks!!!");
    
}

-(NSMutableArray*)parseData:(NSData *)data{
    NSMutableArray *taskAllocations = [[NSMutableArray alloc] init];
    NSDictionary* json = nil;
    if (data) {
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
    }
    
    super.sharedModel.pageNumber = [[json valueForKeyPath:@"currentPage"]intValue];
    
	NSArray *jsonObjects = [json objectForKey:@"resultList"];
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
	for (NSDictionary *dict in jsonObjects)
	{
		WS_JobTaskAllocation *allocation = [[WS_JobTaskAllocation alloc] init];
        [allocation setJobTaskAllocationGroupId:[NSNumber numberWithInt:[dict integerForKey:@"id"]]];
        [allocation setTaskDescription:[dict stringForKey:@"taskDescription"]];
        [allocation setHappyRating:[dict stringForKey:@"happyRating"]];
        [allocation setIsTaskComplete:[dict boolForKey:@"isTaskComplete"]];
        [allocation setTaskDeadline:[dict dateFromJSONStringForKey:@"taskDeadline"]];
        [allocation setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
        [allocation setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
        [allocation setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
        [allocation setInternalNote:[dict stringForKey:@"internalNote"]];
        [allocation setExternalCalendarTag:[dict valueForKeyPath:@"externalCalendarTag"]];
        [allocation setExternalCalendarUUID:[dict valueForKeyPath:@"externalCalendarUuid"]];
        [allocation setDurationInMinutes:[NSNumber numberWithInt:[dict integerForKey:@"durationInMinutes"]]];
        [allocation setDependencyTaskDeadline:[dict dateFromJSONStringForKey:@"dependancyTaskDeadline"]];
        [allocation setJobStageDescription:[dict valueForKeyPath:@"jobStageDescription"]];
        [allocation setJobStageUUID:[dict valueForKeyPath:@"jobStageUuid"]];
        [allocation setTotalTimeLoggedMinutes:[NSNumber numberWithInt:[dict integerForKey:@"totalTimeLoggedMinutes"]]];
        [allocation setIsTaskMilestone:[[dict valueForKeyPath:@"isTaskMilesone"]boolValue]];
        [allocation setUuid:[dict valueForKeyPath:@"uuid"]];
        [allocation setWsVersion:[NSNumber numberWithInteger:[dict integerForKey:@"version"]]];

        NSMutableArray *allocationIntervals;
        NSDictionary *allocationIntervalsDict = [dict objectForKey:@"allocationIntervals"];
        
        for (NSDictionary *intervalDict in allocationIntervalsDict) {
            if (allocationIntervals==nil) {
                allocationIntervals = [[NSMutableArray alloc]init];
            }
            WS_AllocationInterval *interval = [[WS_AllocationInterval alloc]init];
            [interval setAllocationIntervalId:[NSNumber numberWithInt:[intervalDict integerForKey:@"id"]]];
            [interval setStartTime:[intervalDict dateFromJSONStringForKey:@"startTime"]];
            [interval setEndTime:[intervalDict dateFromJSONStringForKey:@"endTime"]];
            [interval setAllocationIntervalStatus:[intervalDict valueForKeyPath:@"allocationIntervalStatus"]];
            [interval setDurationInSeconds:[NSNumber numberWithInt:[intervalDict integerForKey:@"durationInSeconds"]]];
            [interval setDateModified:[intervalDict dateFromJSONStringForKey:@"dateModified"]];
            [interval setUuid:[dict valueForKeyPath:@"uuid"]];
            [interval setWsVersion:[NSNumber numberWithInt:[dict integerForKey:@"version"]]];
            [interval setClassName:[dict stringForKey:@"@class"]];
            [allocationIntervals addObject:interval];
        }
        
        allocation.allocationIntervals = allocationIntervals;
        [taskAllocations addObject:allocation];
	}

    
    return taskAllocations;
}

@end

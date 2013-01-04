//
//  LoadJobTasksCommand.m
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobTaskAllocationsCommand.h"
#import "WS_AllocationInterval.h"
#import "NSNull+Addition.h"
#import "NSDictionary+Helpers.h"

@implementation LoadJobTaskAllocationsCommand

-(void)executeWithPageNumber:(int)page windowSize:(int)windowSize{
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations?currentPage=%d&windowSize=%d",super.sharedModel.loggedInEmployee.trafficEmployeeId,page, windowSize];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
//	NSString *theJSON = [[NSString alloc]
//						 initWithBytes: [super.responseData mutableBytes]
//						 length:[super.responseData length]
//						 encoding:NSUTF8StringEncoding];
//	//---shows the JSON ---
//	NSLog(@"%@", theJSON);

    NSMutableArray *allocations = [[NSMutableArray alloc]init];
    if(super.sharedModel.taskAllocations){
        [allocations addObjectsFromArray:super.sharedModel.taskAllocations];
    }
    
    NSMutableArray *parsedAllocations = [self parseData:super.responseData];
    
    if ([parsedAllocations count] > 0) {
        [allocations addObjectsFromArray:parsedAllocations];
    }
    
    //Re-trigger change event in model
    super.sharedModel.taskAllocations = nil;
    super.sharedModel.taskAllocations = allocations;
    
	if(super.sharedModel.taskAllocations)
    {
        NSLog(@"No Errors");
    }
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
        [allocation setExternalCalendarTag:[dict stringForKey:@"externalCalendarTag"]];
        [allocation setExternalCalendarUUID:[dict stringForKey:@"externalCalendarUuid"]];
        [allocation setDurationInMinutes:[NSNumber numberWithInt:[dict integerForKey:@"durationInMinutes"]]];
        [allocation setDependencyTaskDeadline:[dict dateFromJSONStringForKey:@"dependancyTaskDeadline"]];
        [allocation setJobStageDescription:[dict stringForKey:@"jobStageDescription"]];
        [allocation setJobStageUUID:[dict valueForKeyPath:@"jobStageUuid"]];
        [allocation setTotalTimeLoggedMinutes:[NSNumber numberWithInteger:[dict integerForKey:@"totalTimeLoggedMinutes"]]];
        [allocation setIsTaskMilestone:[dict boolForKey:@"isTaskMilesone"]];
        [allocation setUuid:[dict stringForKey:@"uuid"]];
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
            [interval setAllocationIntervalStatus:[intervalDict stringForKey:@"allocationIntervalStatus"]];
            [interval setDurationInSeconds:[NSNumber numberWithInt:[intervalDict integerForKey:@"durationInSeconds"]]];
            [interval setDateModified:[intervalDict dateFromJSONStringForKey:@"dateModified"]];
            [interval setUuid:[dict stringForKey:@"uuid"]];
            [interval setWsVersion:[NSNumber numberWithInteger:[dict integerForKey:@"version"]]];
            [interval setClassName:[dict stringForKey:@"@class"]];
            [allocationIntervals addObject:interval];
        }
        
        allocation.allocationIntervals = allocationIntervals;
        [taskAllocations addObject:allocation];
	}

    return taskAllocations;
}
@end

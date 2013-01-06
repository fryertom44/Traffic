//
//  GetJobTaskAllocationCommand.m
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "GetJobTaskAllocationCommand.h"
#import "WS_AllocationInterval.h"
#import "NSNull+Addition.h"
#import "NSDictionary+Helpers.h"

@implementation GetJobTaskAllocationCommand
-(void)executeWithAllocationGroupId:(NSNumber*)allocationGroupId{
    super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeallocations/jobtasks/%@",allocationGroupId];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    
    WS_JobTaskAllocation *returnedAllocation = [self parseData:super.responseData];
    
    if(returnedAllocation == nil){
        return;
    }
    
    for (int i = 0; i < [super.sharedModel.taskAllocations count]; i++)
    {
        WS_JobTaskAllocation *jta = super.sharedModel.taskAllocations[i];
        
        if([jta.jobTaskAllocationGroupId isEqualToNumber:returnedAllocation.jobTaskAllocationGroupId]){
            super.sharedModel.taskAllocations[i] = returnedAllocation;
            break;
        }
    }
    self.sharedModel.selectedJobTaskAllocation = returnedAllocation;
    
}

-(WS_JobTaskAllocation*)parseData:(NSData *)data{
    NSDictionary* dict = nil;
    if (data) {
        dict = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
    }
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    WS_JobTaskAllocation *allocation = [[WS_JobTaskAllocation alloc] init];
    [allocation setJobTaskAllocationGroupId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"id"]intValue]]];
    
    if([allocation.jobTaskAllocationGroupId isEqualToNumber:[NSNumber numberWithInt:0]]){
        return nil;
    }
    
    [allocation setTaskDescription:[dict stringForKey:@"taskDescription"]];
    [allocation setHappyRating:[dict stringForKey:@"happyRating"]];
    [allocation setIsTaskComplete:[dict objectForKey:@"isTaskComplete"]];
    [allocation setTaskDeadline:[dict dateFromJSONStringForKey:@"taskDeadline"]];
    [allocation setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
    [allocation setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
    [allocation setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
    [allocation setInternalNote:[dict stringForKey:@"internalNote"]];
    [allocation setExternalCalendarTag:[dict valueForKeyPath:@"externalCalendarTag"]];
    [allocation setExternalCalendarUUID:[dict valueForKeyPath:@"externalCalendarUuid"]];
    [allocation setDurationInMinutes:[NSNumber numberWithInt:[[dict valueForKeyPath:@"durationInMinutes"]intValue]]];
    [allocation setDependencyTaskDeadline:[dict dateFromJSONStringForKey:@"dependancyTaskDeadline"]];
    [allocation setJobStageDescription:[dict stringForKey:@"jobStageDescription"]];
    [allocation setJobStageUUID:[dict valueForKeyPath:@"jobStageUuid"]];
    [allocation setTotalTimeLoggedMinutes:[NSNumber numberWithInteger:[dict integerForKey:@"totalTimeLoggedMinutes"]]];
    [allocation setIsTaskMilestone:[dict objectForKey:@"isTaskMilesone"]];
    [allocation setUuid:[dict valueForKeyPath:@"uuid"]];
    [allocation setTrafficVersion:[NSNumber numberWithInteger:[dict integerForKey:@"version"]]];
    
    NSMutableArray *allocationIntervals;
    NSDictionary *allocationIntervalsDict = [dict objectForKey:@"allocationIntervals"];
    
    for (NSDictionary *intervalDict in allocationIntervalsDict) {
        if (allocationIntervals==nil) {
            allocationIntervals = [[NSMutableArray alloc]init];
        }
        WS_AllocationInterval *interval = [[WS_AllocationInterval alloc]init];
        [interval setStartTime:[intervalDict dateFromJSONStringForKey:@"startTime"]];
        [interval setEndTime:[intervalDict dateFromJSONStringForKey:@"endTime"]];
        [interval setAllocationIntervalStatus:[intervalDict valueForKeyPath:@"allocationIntervalStatus"]];
        [interval setDurationInSeconds:[NSNumber numberWithInt:[[intervalDict valueForKeyPath:@"durationInSeconds"]intValue]]];
        [interval setDateModified:[intervalDict dateFromJSONStringForKey:@"dateModified"]];
        [interval setUuid:[dict valueForKeyPath:@"uuid"]];
        [interval setTrafficVersion:[dict valueForKeyPath:@"version"]];
        [interval setClassName:[dict valueForKeyPath:@"@class"]];

        [allocationIntervals addObject:interval];
    }
    
    allocation.allocationIntervals = allocationIntervals;
    return allocation;
}

-(NSMutableArray*)allocationIntervalsAsDict{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    NSMutableArray *allIntsArray = [[NSMutableArray alloc]init];
    WS_JobTaskAllocation *jta = self.sharedModel.selectedJobTaskAllocation;
    
    for (WS_AllocationInterval *ai in jta.allocationIntervals) {
        NSDictionary *aiDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [df stringFromDate:ai.startTime],@"startTime",
                                [df stringFromDate:ai.endTime],@"endTime",
                                ai.allocationIntervalStatus,@"allocationIntervalStatus",
                                ai.durationInSeconds,@"durationInSeconds",
                                nil];
        [allIntsArray addObject:aiDict];
    }
    return allIntsArray;
}

@end

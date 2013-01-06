//
//  PostJobTaskAllocationCommand.m
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "PostJobTaskAllocationCommand.h"
#import "WS_AllocationInterval.h"
#import "NSDictionary+Helpers.h"
#import "NSNull+Addition.h"

@implementation PostJobTaskAllocationCommand

-(void)execute{
    super.responseData = [NSMutableData data];
//    WS_TimeEntry *timesheet = self.sharedModel.timesheet;
    WS_JobTaskAllocation *allocation = self.sharedModel.selectedJobTaskAllocation;
//    WS_JobTask *task = self.sharedModel.selectedJobTask;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    NSString *jta_dependencyTaskDeadline = [df stringFromDate:allocation.dependencyTaskDeadline];
    NSString *jta_externalCalendarTag = allocation.externalCalendarTag;
    NSString *jta_taskDeadline = [df stringFromDate:allocation.taskDeadline];
    NSNumber *jta_durationInMinutes = allocation.durationInMinutes;
    NSString *jta_jobStageDescription = allocation.jobStageDescription;
    NSString *jta_jobStageUUID = allocation.jobStageUUID;
    NSString *jta_happyRating = allocation.happyRating;
    NSNumber *jta_jobTaskAllocationGroupId = allocation.jobTaskAllocationGroupId;
    NSString *jta_externalCalendarUUID = allocation.externalCalendarUUID;
    NSNumber *jta_isTaskMilestone = [NSNumber numberWithBool:allocation.isTaskMilestone];
    NSNumber *jta_isTaskComplete = [NSNumber numberWithBool:allocation.isTaskComplete];
    NSString *jta_uuid = allocation.uuid;
    NSString *jta_taskDescription = allocation.taskDescription;
    NSNumber *jta_version = allocation.trafficVersion;
    NSNumber *jta_totalTimeLoggedMinutes = allocation.totalTimeLoggedMinutes;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNull nullWhenNil:jta_dependencyTaskDeadline],@"dependancyTaskDeadline",
//                                    [NSNull nullWhenNil:jta_externalCalendarTag],@"externalCalendarTag",
//                                    [NSNull nullWhenNil:jta_taskDeadline],@"taskDeadline",
//                                    [NSDictionary dictionaryWithObjectsAndKeys:allocation.jobId,@"id",nil],@"jobId",
//                                    [NSNull nullWhenNil:jta_durationInMinutes],@"durationInMinutes",
//                                    [NSNull nullWhenNil:jta_jobStageDescription],@"jobStageDescription",
//                                    [NSNull nullWhenNil:jta_jobStageUUID ],@"jobStageUUID",
                                    [NSNull nullWhenNil:jta_happyRating],@"happyRating",
//                                    [NSNull nullWhenNil:jta_version],@"version",
                                    [NSNull nullWhenNil:jta_jobTaskAllocationGroupId],@"id",
//                                    [NSNull nullWhenNil:jta_externalCalendarUUID],@"externalCalendarUUID",
//                                    [NSNull nullWhenNil:[self allocationIntervalsAsDict]],@"allocationIntervals",
//                                    [NSDictionary dictionaryWithObjectsAndKeys:allocation.jobTaskId,@"id",nil],@"jobTaskId",
//                                    [NSDictionary dictionaryWithObjectsAndKeys:allocation.trafficEmployeeId,@"id", nil],@"trafficEmployeeId",
//                                    [NSNull nullWhenNil:jta_isTaskMilestone],@"isTaskMilesone",
//                                    [NSNull nullWhenNil:jta_isTaskComplete],@"isTaskComplete",
//                                    [NSNull nullWhenNil:jta_uuid],@"uuid",
//                                    [NSNull nullWhenNil:jta_taskDescription],@"taskDescription",
//                                    [NSNull nullWhenNil:jta_totalTimeLoggedMinutes],@"totalTimeLoggedMinutes",
//                                    [df stringFromDate:[NSDate date]],@"dateModified",
                                    nil];

    NSLog(@"POST Allocation: %@",[jsonDictionary description]);
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeallocations/jobtasks"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
}

-(NSMutableArray*)allocationIntervalsAsDict{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    NSMutableArray *allIntsArray;
    WS_JobTaskAllocation *jta = self.sharedModel.selectedJobTaskAllocation;
    
    for (WS_AllocationInterval *ai in jta.allocationIntervals) {
        if (allIntsArray==nil) {
            allIntsArray = [[NSMutableArray alloc]init];
        }
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


#pragma mark - NSURLConnection Delegates

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
	NSString *theJSON = [[NSString alloc]
						 initWithBytes: [super.responseData mutableBytes]
						 length:[super.responseData length]
						 encoding:NSUTF8StringEncoding];
	//---shows the JSON ---
	NSLog(@"%@", theJSON);
    
    NSMutableArray *allocations = [[NSMutableArray alloc]init];
    if(super.sharedModel.taskAllocations){
        [allocations addObjectsFromArray:super.sharedModel.taskAllocations];
    }
    
    WS_JobTaskAllocation *returnedAllocation = [self parseData:super.responseData];
    
    if(returnedAllocation == nil){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Update Task Allocation Failed"
                                                          message:@"The request sent by the client was syntactically incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
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
    
    if(self.delegate){
        [self.delegate saveSuccessful];
    }
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
        [interval setAllocationIntervalId:[NSNumber numberWithInt:[[intervalDict valueForKeyPath:@"id"]intValue]]];
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


@end

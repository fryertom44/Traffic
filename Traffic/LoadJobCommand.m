//
//  LoadJobCommand.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobCommand.h"
#import "WS_Job.h"
#import "ParseJobTaskFromJobData.h"
#import "NSDictionary+Helper.h"
@implementation LoadJobCommand

- (void)executeWithJobId:(NSNumber*)jobId{
    
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/job/%@",jobId.stringValue];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //HACK: Store raw data in model, so that job task parser can extract job tasks from it
//    self.sharedModel.selectedJobAsData = super.responseData;
    
	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
	NSString *theJSON = [[NSString alloc]
						 initWithBytes: [super.responseData mutableBytes]
						 length:[super.responseData length]
						 encoding:NSUTF8StringEncoding];
	//---shows the JSON ---
	NSLog(@"%@", theJSON);
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    NSDictionary* json = nil;
    if (super.responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
        
        WS_Job *job = [[WS_Job alloc] init];
        [job setJobId:[NSNumber numberWithInt:[[json valueForKeyPath:@"id"]intValue]]];
        [job setJobDetailId:[NSNumber numberWithInt:[[json valueForKeyPath:@"jobDetailId"]intValue]]];
        [job setJobDeadline:[df dateFromString:[json valueForKeyPath:@"internalDeadline"]]];
        [job setJobNumber:[json valueForKeyPath:@"jobNumber"]];

        self.sharedModel.selectedJob = job;
        self.sharedModel.selectedJobTask = [self parseJobTasksDictionary:[json objectForKey:@"jobTasks"]];
        self.sharedModel.timesheet.taskRate = self.sharedModel.selectedJobTask.rate;
    }
}

- (WS_JobTask*)parseJobTasksDictionary:(NSDictionary*)jobTasksDict{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
    for (NSDictionary *dict in jobTasksDict)
	{
		WS_JobTask *jobTask = [[WS_JobTask alloc] init];
        [jobTask setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"id"]intValue]]];
        [jobTask setVersion:[NSNumber numberWithInt:[[dict valueForKeyPath:@"version"]intValue]]];
		[jobTask setJobTaskDescription:[dict getStringUsingkey:@"description" fallback:@""]];
        [jobTask setInternalNote:[dict getStringUsingkey:@"internalNote" fallback:@""]];
        [jobTask setQuantity:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"quantity"]floatValue]]];
        [jobTask setChargeBandId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"chargebandId"]intValue]]];
        [jobTask setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId"]intValue]]];
        
        if([dict respondsToSelector:NSSelectorFromString(@"jobTaskCompletionDate")]){
            [jobTask setJobTaskCompletionDate:[df dateFromString:[dict valueForKeyPath:@"jobTaskCompletionDate"]]];
        }
        [jobTask setStudioAllocationMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"studioAllocationMinutes"]floatValue]]];
        [jobTask setTaskDeadline:[df dateFromString:[dict valueForKeyPath:@"taskDeadline"]]];
        [jobTask setTaskStartDate:[df dateFromString:[dict valueForKeyPath:@"taskStartDate"]]];
		[jobTask setJobStageDescription:[dict getStringUsingkey:@"jobStageDescription" fallback:@""]];
        [jobTask setDurationMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"durationMinutes"]floatValue]]];
        [jobTask setTotalTimeLoggedMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeLoggedMinutes"]floatValue]]];
        [jobTask setTotalTimeLoggedBillableMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeLoggedBillableMinutes"]floatValue]]];
        [jobTask setTotalTimeAllocatedMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeAllocatedMinutes"]floatValue]]];
        
        if ([jobTask.jobTaskId isEqualToNumber:self.sharedModel.selectedJobTaskAllocation.jobTaskId]) {
            return jobTask;
        }
        [jobTask setCost:[self newMoneyFromDict:[dict objectForKey:@"cost"]]];
        [jobTask setRate:[self newMoneyFromDict:[dict objectForKey:@"rate"]]];
        [jobTask setRateOtherCurrency:[self newMoneyFromDict:[dict objectForKey:@"rateOtherCurrency"]]];
        [jobTask setBillableNet:[self newMoneyFromDict:[dict objectForKey:@"billableNet"]]];
	}
    return nil;
}
@end

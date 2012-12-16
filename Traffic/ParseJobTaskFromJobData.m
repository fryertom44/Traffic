//
//  ParseJobTask.m
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "ParseJobTaskFromJobData.h"
#import "WS_JobTask.h"
#import "NSDictionary+Helper.h"

@implementation ParseJobTaskFromJobData

+(WS_JobTask*)parseData:(NSData *)data fetchJobTaskWithId:(NSNumber*)jobTaskId{
    NSDictionary* json = nil;
    if (data) {
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
    }
    
	NSArray *jsonObjects = [json objectForKey:@"jobTasks"];
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
	for (NSDictionary *dict in jsonObjects)
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
            NSString *completionDateString = [dict valueForKeyPath:@"jobTaskCompletionDate"];
            [jobTask setJobTaskCompletionDate:[df dateFromString:[dict valueForKeyPath:@"jobTaskCompletionDate"]]];
        }
        [jobTask setStudioAllocationMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"studioAllocationMinutes"]floatValue]]];
        [jobTask setTaskDeadline:[df dateFromString:[dict valueForKeyPath:@"taskDeadline"]]];
        [jobTask setTaskStartDate:[df dateFromString:[dict valueForKeyPath:@"taskStartDate"]]];
		[jobTask setJobStageDescription:[dict getStringUsingkey:@"jobStageDescription" fallback:@""]];
        NSLog([NSString stringWithFormat:@"durationMinutes: %@",[dict valueForKeyPath:@"durationMinutes"]]);
        [jobTask setDurationMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"durationMinutes"]floatValue]]];
        [jobTask setTotalTimeLoggedMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeLoggedMinutes"]floatValue]]];
        [jobTask setTotalTimeLoggedBillableMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeLoggedBillableMinutes"]floatValue]]];
        [jobTask setTotalTimeAllocatedMinutes:[NSNumber numberWithFloat:[[dict valueForKeyPath:@"totalTimeAllocatedMinutes"]floatValue]]];
        
        if ([jobTask.jobTaskId isEqualToNumber:jobTaskId]) {
            return jobTask;
        }
        
	}
}

@end

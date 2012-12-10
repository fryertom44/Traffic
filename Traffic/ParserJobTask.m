//
//  ParserJobTask.m
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "ParserJobTask.h"
#import "WS_JobTask.h"
#import "GlobalModel.h"
#import "NSDate+Helper.h"

@implementation ParserJobTask

+(void)parseData:(NSData *)data{
    NSMutableArray *jobTasks = [[NSMutableArray alloc] init];
    NSDictionary* json = nil;
    if (data) {
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:nil];
    }
    
	NSArray *jsonObjects = [json objectForKey:@"resultList"];
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
	for (NSDictionary *dict in jsonObjects)
	{
		WS_JobTask *jobTask = [[WS_JobTask alloc] init];
		[jobTask setTaskDescription:[dict valueForKeyPath:@"taskDescription"]];
        [jobTask setHappyRating:[dict valueForKeyPath:@"happyRating"]];
        [jobTask setIsTaskComplete:[[dict valueForKeyPath:@"isTaskComplete"]boolValue]];
        [jobTask setTaskDeadline:[df dateFromString:[dict valueForKeyPath:@"taskDeadline"]]];
        [jobTask setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
        [jobTask setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
		[jobTask setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
        
        [jobTasks addObject:jobTask];
	}
    GlobalModel *globalModel = [GlobalModel sharedInstance];
    globalModel.allocatedTasks = jobTasks;
    [globalModel printOutTasks];
}
@end

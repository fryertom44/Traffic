//
//  RefreshJobTaskAllocationsCommand.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "RefreshJobTaskAllocationsCommand.h"
#import "ParserJobTaskAllocation.h"
#import "NSDictionary+Helper.h"

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
		[allocation setTaskDescription:[dict valueForKeyPath:@"taskDescription"]];
        [allocation setHappyRating:[dict valueForKeyPath:@"happyRating"]];
        [allocation setIsTaskComplete:[[dict valueForKeyPath:@"isTaskComplete"]boolValue]];
        [allocation setTaskDeadline:[df dateFromString:[dict valueForKeyPath:@"taskDeadline"]]];
        [allocation setJobTaskId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobTaskId.id"]intValue]]];
        [allocation setJobId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"jobId.id"]intValue]]];
		[allocation setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"trafficEmployeeId.id"]intValue]]];
        [allocation setInternalNote:[dict getStringUsingkey:@"internalNote" fallback:@""]];
        
        [taskAllocations addObject:allocation];
	}
    
    return taskAllocations;
}

@end

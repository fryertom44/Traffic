//
//  LoadJobDetail.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobDetailCommand.h"
#import "KeychainItemWrapper.h"
#import "WS_JobDetail.h"
#import "DetailViewController.h"
#import "NSDictionary+Helper.h"
#import "GlobalModel.h"

@implementation LoadJobDetailCommand

- (void)executeWithJobDetailId:(NSNumber*)jobDetailId{
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/jobdetail/%@",jobDetailId.stringValue];
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
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSDictionary* json = nil;
    if (super.responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
        
        WS_JobDetail *jobDetail = [[WS_JobDetail alloc] init];
		[jobDetail setJobContactId:[NSNumber numberWithInt:[[json valueForKeyPath:@"jobContactId"]intValue]]];
        [jobDetail setJobDetailId:[NSNumber numberWithInt:[[json valueForKeyPath:@"jobDetail.id"]intValue]]];
        [jobDetail setJobDescription:[json getStringUsingkey:@"description" fallback:@""]];
        [jobDetail setJobTitle:[json getStringUsingkey:@"name" fallback:@""]];
        [jobDetail setAccountManagerId:[NSNumber numberWithInt:[[json valueForKeyPath:@"accountManagerId"]intValue]]];
        [jobDetail setOwnerProjectId:[NSNumber numberWithInt:[[json valueForKeyPath:@"ownerProjectId"]intValue]]];
        
        self.sharedModel.selectedJobDetail = jobDetail;
    }
}

@end

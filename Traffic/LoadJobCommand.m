//
//  LoadJobCommand.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobCommand.h"
#import "KeychainItemWrapper.h"
#import "WS_Job.h"
#import "DetailViewController.h"
#import "GlobalModel.h"
#import "ParseJobTaskFromJobData.h"

@implementation LoadJobCommand

@synthesize responseData;

- (void)executeAndUpdateComponent:(id)component
                            jobId:(NSNumber*)jobId
                        optionalJobTaskId:(NSNumber*)optionalJobTaskId{
	responseData = [NSMutableData data];
	componentToUpdate = component;
    jobTaskId = optionalJobTaskId;
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/job/%@",jobId.stringValue];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"TrafficLogin" accessGroup:nil];
        NSString* email = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        NSString* apiKey = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:email
                                                                    password:apiKey
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //HACK: Store raw data in model, so that job task parser can extract job tasks from it
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    sharedModel.selectedJobAsData = responseData;
    
	NSLog(@"DONE. Received Bytes: %d", [responseData length]);
	NSString *theJSON = [[NSString alloc]
						 initWithBytes: [responseData mutableBytes]
						 length:[responseData length]
						 encoding:NSUTF8StringEncoding];
	//---shows the JSON ---
	NSLog(@"%@", theJSON);
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSDictionary* json = nil;
    if (responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:nil];
        
        WS_Job *job = [[WS_Job alloc] init];
        [job setJobId:[NSNumber numberWithInt:[[json valueForKeyPath:@"id"]intValue]]];
        [job setJobDetailId:[NSNumber numberWithInt:[[json valueForKeyPath:@"jobDetailId"]intValue]]];
        [job setJobDeadline:[df dateFromString:[json valueForKeyPath:@"internalDeadline"]]];
        [job setJobNumber:[json valueForKeyPath:@"jobNumber"]];
        DetailViewController *dvc = (DetailViewController*)componentToUpdate;
        [dvc setJob:job];
        
        if(jobTaskId){
           [dvc setTask:[ParseJobTaskFromJobData parseData:responseData fetchJobTaskWithId:jobTaskId]];
        }
        
    }    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
}

@end

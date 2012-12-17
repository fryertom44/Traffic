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

@synthesize responseData;

- (void)executeWithJobDetailId:(NSNumber*)jobDetailId{
	responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/jobdetail/%@",jobDetailId.stringValue];
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
}

-(GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

@end

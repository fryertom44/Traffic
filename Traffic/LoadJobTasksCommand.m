//
//  LoadJobTasksCommand.m
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobTasksCommand.h"
#import "ParserJobTask.h"
#import "GlobalModel.h"

@implementation LoadJobTasksCommand
@synthesize responseData;

- (void)executeAndUpdateComponent:(id)component
                             page:(int)page{
	responseData = [NSMutableData data];
	componentToUpdate = component;
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeallocations/jobtasks?currentPage=%d",page];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"fryertom@gmail.com"
                                                                    password:@"MR6gFeqG585J5SVZ7Lnv128wHhT2EBgjl5C7F2i2"
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
	
    [ParserJobTask parseData:responseData];
    
    GlobalModel *globalModel = [GlobalModel sharedInstance];
    
	if(globalModel.allocatedTasks)
    {
        NSLog(@"No Errors");
        [componentToUpdate reloadData];
    }
    else
		NSLog(@"Error - there are no job tasks!!!");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
}

@end

//
//  LoginCommand.m
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadTimeEntriesCommand.h"
#import "ParserTimeEntry.h"

@implementation LoadTimeEntriesCommand
@synthesize timeEntries;
@synthesize responseData;

- (void)loadTimeEntries {
    
	responseData = [NSMutableData data];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.sohnar.com/TrafficLiteServer/openapi/timeentries?startDate=2010-01-01&endDate=2015-01-01"]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];

}



// NSURLConnection Delegates
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
	
	//Initialize the delegate.
	ParserTimeEntry *timeEntriesParser = [[ParserTimeEntry alloc] initParser];
	
	//Start parsing the XML file.
	timeEntries = [timeEntriesParser parseData:responseData];
    
	if(timeEntries)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
	
//	[self.tableView reloadData];
//	[responseData release];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
//	[responseData release];
//	[connection release];
}

@end

//
//  LoadProjectCommand.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadProjectCommand.h"
#import "WS_Project.h"
#import "NSDictionary+Helpers.h"

@implementation LoadProjectCommand

- (void)executeWithProjectId:(NSNumber*)projectId{
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/project/%@",projectId.stringValue];
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
    
    NSDictionary* json = nil;
    if (super.responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
        
        WS_Project *project = [[WS_Project alloc] init];
		[project setProjectId:[NSNumber numberWithInt:[[json valueForKeyPath:@"id"]intValue]]];
        [project setProjectName:[json stringForKey:@"name"]];
        [project setClientCRMEntryId:[NSNumber numberWithInt:[[json valueForKeyPath:@"clientCRMEntryId"]intValue]]];
        
        self.sharedModel.selectedProject = project;
    }
}

@end

//
//  LoadClient.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadClientCommand.h"
#import "WS_Client.h"

@implementation LoadClientCommand

- (void)executeWithClientCRMId:(NSNumber*)clientCRMId{
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/crm/client/%@",clientCRMId.stringValue];
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
    }
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    WS_Client *client = [[WS_Client alloc] init];
    [client setClientId:[NSNumber numberWithInt:[[json valueForKeyPath:@"id"]intValue]]];
    [client setClientName:[json valueForKeyPath:@"name"]];

    self.sharedModel.selectedClient = client;
}


@end

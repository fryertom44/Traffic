//
//  LoginCommand.m
//  Traffic
//
//  Created by Tom Fryer on 07/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoginCommand.h"
#import "LoginViewController.h"
#import "GlobalModel.h"
#import "WS_TrafficEmployee.h"

@implementation LoginCommand

//@synthesize loginViewController=_loginViewController;

//These are for DEBUG purposes
//const NSString* username = @"fryertom@gmail.com";
//const NSString* password = @"MR6gFeqG585J5SVZ7Lnv128wHhT2EBgjl5C7F2i2";

- (void)executeWithUsername:(NSString*)username password:(NSString*)password delegate:(id)delegate{
	super.responseData = [NSMutableData data];
    self.delegate = delegate;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"TrafficLogin" accessGroup:nil];
    NSString* email = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/staff/employee?filter=emailAddress|EQ|\"%@\"",email];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [super connection:connection didFailWithError:error];
    [self.delegate loginOperationCompleted:nil withResult:FALSE errorMessage:@"Connection failure"];
}

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
    NSArray *jsonObjects = [json objectForKey:@"resultList"];
	
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
	for (NSDictionary *dict in jsonObjects)
	{
		WS_TrafficEmployee *employee = [[WS_TrafficEmployee alloc] init];
        [employee setTrafficEmployeeId:[NSNumber numberWithInt:[[dict valueForKeyPath:@"id"]intValue]]];
		[employee setFirstName:[dict valueForKeyPath:@"employeeDetails.personalDetails.firstName"]];
        [employee setLastName:[dict valueForKeyPath:@"employeeDetails.personalDetails.lastName"]];
        GlobalModel *sharedModel = [GlobalModel sharedInstance];
        sharedModel.loggedInEmployee = employee;
        [self.delegate loginOperationCompleted:nil withResult:TRUE errorMessage:@"Success"];

        return;
    }
    
    [self.delegate loginOperationCompleted:nil withResult:FALSE errorMessage:@"Username not found"];
    
}

@end

//
//  LoadTrafficEmployee.m
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadTrafficEmployeeCommand.h"
#import "WS_TrafficEmployee.h"

@implementation LoadTrafficEmployeeCommand

- (void)executeWithTrafficEmployeeId:(NSNumber*)trafficEmployeeId{
	super.responseData = [NSMutableData data];
    NSString *urlString = [NSString stringWithFormat:@"https://api.sohnar.com/TrafficLiteServer/openapi/staff/employee/%@",trafficEmployeeId.stringValue];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	[myConnection start];
    
}

#pragma mark - NSURLConnection Delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//	NSLog(@"DONE. Received Bytes: %d", [super.responseData length]);
//	NSString *theJSON = [[NSString alloc]
//						 initWithBytes: [super.responseData mutableBytes]
//						 length:[super.responseData length]
//						 encoding:NSUTF8StringEncoding];
//	//---shows the JSON ---
//	NSLog(@"%@", theJSON);
    
    NSDictionary* json = nil;
    if (super.responseData) {
        json = [NSJSONSerialization
                JSONObjectWithData:super.responseData
                options:kNilOptions
                error:nil];
        
        WS_TrafficEmployee *employee = [[WS_TrafficEmployee alloc] init];
		[employee setFirstName:[json valueForKeyPath:@"employeeDetails.personalDetails.firstName"]];
        [employee setLastName:[json valueForKeyPath:@"employeeDetails.personalDetails.lastName"]];
        [employee setCostPerHour:[self newMoneyFromDict:[json valueForKeyPath:@"employeeDetails.costPerHour"]]];
        self.sharedModel.selectedOwner = employee;

    }
}

@end

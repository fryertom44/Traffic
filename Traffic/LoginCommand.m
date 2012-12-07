//
//  LoginCommand.m
//  Traffic
//
//  Created by Tom Fryer on 07/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoginCommand.h"
#import "LoginViewController.h"

@implementation LoginCommand
@synthesize responseData;
@synthesize loginViewController=_loginViewController;

//These are for DEBUG purposes
const NSString* username = @"fryertom@gmail.com";
const NSString* password = @"MR6gFeqG585J5SVZ7Lnv128wHhT2EBgjl5C7F2i2";

- (void)executeWithUsername:(NSString*)username password:(NSString*)password sender:(id)sender{
	responseData = [NSMutableData data];
    self.loginViewController = (LoginViewController *)sender;
    NSString *urlString = @"https://api.sohnar.com/TrafficLiteServer/openapi/application/country/GB";
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
        NSString* email = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        NSString* apiKey = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:email
                                                                    password:apiKey
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");
    }
    else {
        NSLog(@"previous authentication failure");
        [self.loginViewController loginOperationCompleted:nil
                                               withResult:FALSE
                                             errorMessage:@"Authentication failure"];
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
    [self.loginViewController loginOperationCompleted:nil
                                           withResult:TRUE
                                         errorMessage:@"Success"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error during connection: %@", [error description]);
    [self.loginViewController loginOperationCompleted:nil
                                           withResult:FALSE
                                         errorMessage:[error description]];
}


@end

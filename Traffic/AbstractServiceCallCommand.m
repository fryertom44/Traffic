//
//  AbstractServiceCallCommand.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AbstractServiceCallCommand.h"
#import "KeychainItemWrapper.h"
#import "GlobalModel.h"
#import "NSNull+Addition.h"

@implementation AbstractServiceCallCommand

@synthesize responseData;

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
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [NSException raise:@"AbstractServiceCallCommand:connectionDidFinishLoading called" format:@"You must override this method in the command subclass"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSLog(@"Error during connection: %@", [error description]);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error during connection"
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

-(NSString*)jsonTimeFormatString{
    return @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
}

-(Money*)newMoneyFromDict:(NSDictionary*)dict{
    if (![[NSNull null]isEqual:dict]) {
//        NSLog(@"newMoneyFromDict: %@",[dict description]);

        id amount = [dict objectForKey:@"amountString"];
    
        if(amount!=nil){
            Money *newMoney = [[Money alloc]init];
            newMoney.amount = [NSNumber numberWithFloat:[[dict objectForKey:@"amountString"]floatValue]];
            newMoney.currencyType = [dict valueForKeyPath:@"currencyType"];
            return newMoney;
        }
    }
    return nil;
}

@end

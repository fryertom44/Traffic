//
//  LoginCommand.h
//  Traffic
//
//  Created by Tom Fryer on 07/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface LoginCommand : NSObject

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic) LoginViewController *loginViewController;

-(void)executeWithUsername:(NSString*)username password:(NSString*)password sender:(id)sender;

@end

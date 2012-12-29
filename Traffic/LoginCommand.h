//
//  LoginCommand.h
//  Traffic
//
//  Created by Tom Fryer on 07/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "AbstractServiceCallCommand.h"

@interface LoginCommand : AbstractServiceCallCommand

//@property (nonatomic) LoginViewController *loginViewController;
@property (nonatomic) id <LoginOperationDelegate> delegate;
-(void)executeWithUsername:(NSString*)username password:(NSString*)password delegate:(id)delegate;

@end

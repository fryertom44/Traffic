//
//  LoginViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOperation.h"
#import "KeychainItemWrapper.h"

@class LoginViewController;

// Describes an object that is notified when the user credentials have been authenticated.
@protocol LoginViewControllerDelegate <NSObject>

// Invoked when the user credentials have been successfully authenticated.
// Check the LoginViewController's loginOperation to get the authenticated username and password.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController;

@end

@interface LoginViewController : UITableViewController <LoginOperationDelegate, UITextFieldDelegate> {
    
}

// Properties
@property (nonatomic, assign) id<LoginViewControllerDelegate>    delegate;
@property (nonatomic, retain) LoginOperation                    *loginOperation;

// Outlets
@property (nonatomic, retain) IBOutlet UITextField              *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField              *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton                 *submitButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *waitIndicator;

// Actions
- (IBAction)submit:(id)sender;

@end

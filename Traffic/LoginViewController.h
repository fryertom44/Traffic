//
//  LoginViewController.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@class LoginViewController;
@class LoginCommand;

@protocol LoginViewControllerDelegate <NSObject>
// Invoked when the user credentials have been successfully authenticated.
-(void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController;
@end

// Describes an object that is notified when the user credentials have been authenticated.
@protocol LoginOperationDelegate <NSObject>
// Invoked after a login attempt completes.
-(void)loginOperationCompleted:(LoginCommand *)loginOperation
                     withResult:(BOOL)successfulLogin
                   errorMessage:(NSString *)errorMessage;
@end


@interface LoginViewController : UITableViewController <LoginOperationDelegate,UITextFieldDelegate> {
    
}

// Properties
@property (nonatomic, assign) id<LoginViewControllerDelegate>    delegate;

// Outlets
@property (nonatomic, retain) IBOutlet UITextField              *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField              *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton                 *submitButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *waitIndicator;

// Actions
- (IBAction)submit:(id)sender;

@end

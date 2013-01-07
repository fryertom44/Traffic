//
//  LoginViewController.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCommand.h"
#import "GlobalModel.h"
#import <RestKit.h>
#import "ConfigureRestkitCommand.h"

@implementation LoginViewController

#pragma mark - Properties
//@synthesize delegate=_delegate;
//@synthesize usernameTextField=_usernameTextField;
//@synthesize passwordTextField=_passwordTextField;
//@synthesize submitButton=_submitButton;
//@synthesize waitIndicator=_waitIndicator;

#pragma mark - Helper methods
- (void)releaseOutlets
{
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.submitButton = nil;
    self.waitIndicator = nil;
}

- (void)setIsWaiting:(BOOL)waiting
{
    if (waiting)
    {
        [self.waitIndicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.submitButton.enabled = NO;
    }
    else
    {
        [self.waitIndicator stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.submitButton.enabled = YES;
    }
}

#pragma mark - Actions
- (IBAction)submit:(id)sender
{
//    if (!self.loginOperation)
//        return;
    
    NSString *username = self.usernameTextField.text;
    if (!username || [username length] == 0)
        return;
    
    NSString *password = self.passwordTextField.text;
    if (!password || [password length] == 0)
        return;
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"TrafficLogin" accessGroup:nil];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"filter" : [NSString stringWithFormat:@"emailAddress|EQ|\"%@\"",username]}];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    [objectManager getObjectsAtPath:@"staff/employee" parameters:params
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         NSArray *results = [mappingResult array];
                         WS_TrafficEmployee *currentUser = [results objectAtIndex:0];
                         if(currentUser.trafficVersion >= 0)
                         {
                             [GlobalModel sharedInstance].loggedInEmployee = currentUser;
                             [self.delegate loginViewControllerLoggedIn:self];
                         }
                         else{
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failure"
                                                                             message:@"The user name was not recognised."
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             [alert show];
                         }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failure"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);

    }];
    [self setIsWaiting:NO];
}

#pragma mark - LoginOperationDelegate members
//- (void)loginOperationCompleted:(LoginCommand *)loginOperation
//                     withResult:(BOOL)successfulLogin
//                   errorMessage:(NSString *)errorMessage
//{
//    [self setIsWaiting:NO];
//    
//    if (successfulLogin)
//    {
//        // Let this object's delegate know that the login was a success.
//        [self.delegate loginViewControllerLoggedIn:self];
//    }
//    else
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Failure"
//                                                          message:errorMessage
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
//    }
//}

#pragma mark - UITextFieldDelegate members
// Called when the 'return' key is pressed. Return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField)
    {
        // Move input focus to the password field.
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        // Simulate clicking the Submit button.
        [self submit:nil];
    }
    return NO;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background_landscape.png"]];
    [self.tableView setBackgroundView:imageView];
    self.passwordTextField.secureTextEntry = TRUE;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"TrafficLogin" accessGroup:nil];
    self.passwordTextField.text = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    self.usernameTextField.text = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    // Configure the animated icon that is displayed
    // while the user's credentials are being verified.
    [self setIsWaiting:NO];
    self.waitIndicator.hidden = YES;
    self.waitIndicator.hidesWhenStopped = YES;
    
    // Set this object as the delegate for the text fields, so that
    // when the user hits the RETURN key we can perform custom logic.
    self.passwordTextField.delegate = self;
    self.usernameTextField.delegate = self;
    
    // Give input focus to the username field.
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)handleFailureWithOperation:(RKObjectRequestOperation*)operation error:(NSError*)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failure"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
};

@end

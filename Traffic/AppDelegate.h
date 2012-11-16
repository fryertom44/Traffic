//
//  AppDelegate.h
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class MasterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate>
{
//    LoginViewController *loginViewController;
//    MasterViewController *masterViewController;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MasterViewController *masterViewController;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@end

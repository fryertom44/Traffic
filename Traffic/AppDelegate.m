//
//  AppDelegate.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
//#import "LoginOperation.h"
#import "MasterViewController.h"
#import "GlobalModel.h"

@implementation AppDelegate

@synthesize window;
@synthesize loginViewController;
@synthesize splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//        
//        [_window makeKeyAndVisible];
//        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
//        UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
//        [loginController setModalPresentationStyle:UIModalPresentationFullScreen];
//        [splitViewController presentViewController:loginController animated:YES completion:NULL];
//    }

//    return YES;
    
    self.loginViewController = (LoginViewController *)self.window.rootViewController;
    self.loginViewController.delegate = self;
//    self.loginViewController.loginOperation = [[LoginOperation alloc] init];

    // Show the window.
    [self.window makeKeyAndVisible];

    return YES;
}


// Invoked when the user is successfully logged in.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController
{
//    [self.splitViewController dismissViewControllerAnimated:YES completion:NULL];
//    
//    LoginOperation *loginOp = self.loginViewController.loginOperation;
//    
//    NSLog(@"Logged in. User Name='%@' Password='%@'",
//          loginOp.authenticatedUsername,
//          loginOp.authenticatedPassword);
    
//    [loginOp deleteAuthenticatedData];
    self.loginViewController = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        self.splitViewController = (UISplitViewController*)[storyboard instantiateViewControllerWithIdentifier:@"splitViewController"];
        UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
        self.splitViewController.delegate = (id)navigationController.topViewController;
        [UIApplication sharedApplication].delegate.window.rootViewController = self.splitViewController;
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"rootNav"];
        [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;

    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    if(self.sharedModel.isRecordingTime){
//        self.sharedModel.timerStartDate = [NSDate date];
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(self.sharedModel.isRecordingTime){
        self.sharedModel.timeElapsedInterval=[[NSDate date] timeIntervalSinceDate:self.sharedModel.timerStartDate];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(GlobalModel*)sharedModel{
    return [GlobalModel sharedInstance];
}

@end

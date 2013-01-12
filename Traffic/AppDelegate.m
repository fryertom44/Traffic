//
//  AppDelegate.m
//  Traffic
//
//  Created by Tom Fryer on 14/10/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MasterViewController.h"
#import "GlobalModel.h"
#import "ConfigureRestkitCommand.h"
#import "ServiceCommandLibrary.h"

@implementation AppDelegate

@synthesize window;
@synthesize loginViewController;
@synthesize splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialize RestKit
    [ConfigureRestkitCommand execute];
    
    //Get Big Data from store or load from server
    [self LoadStoredData];
    
    self.loginViewController = (LoginViewController *)self.window.rootViewController;
    self.loginViewController.delegate = self;

    // Show the window.
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)LoadStoredData
{
    NSDictionary *params = @{@"windowSize" : @"5000"};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Way to clear the store
    [defaults removeObjectForKey:kClientsStoreKey];
    [defaults removeObjectForKey:kProjectsStoreKey];
    [defaults removeObjectForKey:kJobDetailsStoreKey];
    [defaults removeObjectForKey:kJobsStoreKey];
    [defaults removeObjectForKey:kEmployeesStoreKey];
    [defaults synchronize];
    
    NSData *storedClientData = [defaults objectForKey:kClientsStoreKey];
    
    if(!storedClientData)
        [ServiceCommandLibrary loadClientsWithParams:params];
    else{
        self.sharedModel.clients = [NSKeyedUnarchiver unarchiveObjectWithData:storedClientData];
        NSLog(@"Unarchived Clients: %@", [self.sharedModel.clients description]);
    }
    
    NSData *storedProjectsData = [defaults objectForKey:kProjectsStoreKey];
    if(!storedProjectsData)
        [ServiceCommandLibrary loadProjectsWithParams:params];
    else{
        self.sharedModel.projects = [NSKeyedUnarchiver unarchiveObjectWithData:storedProjectsData];
        NSLog(@"Unarchived Projects: %@", [self.sharedModel.projects description]);
    }
    
    NSData *storedJobsData = [defaults objectForKey:kJobsStoreKey];
    if(!storedJobsData)
        [ServiceCommandLibrary loadJobsWithParams:params];
    else{
        self.sharedModel.jobs = [NSKeyedUnarchiver unarchiveObjectWithData:storedJobsData];
        NSLog(@"Unarchived Jobs: %@", [self.sharedModel.jobs description]);
    }
    
    NSData *storedJobDetailsData = [defaults objectForKey:kJobDetailsStoreKey];
    if(!storedJobDetailsData)
        [ServiceCommandLibrary loadJobDetailsWithParams:params];
    else{
        self.sharedModel.jobDetails = [NSKeyedUnarchiver unarchiveObjectWithData:storedJobDetailsData];
        NSLog(@"Unarchived Job Details: %@", [self.sharedModel.jobDetails description]);
    }
    
    NSData *storedEmployeesData = [defaults objectForKey:kEmployeesStoreKey];
    if(!storedEmployeesData)
        [ServiceCommandLibrary loadEmployeesWithParams:params];
    else{
        self.sharedModel.employees = [NSKeyedUnarchiver unarchiveObjectWithData:storedEmployeesData];
        NSLog(@"Unarchived Employees: %@", [self.sharedModel.employees description]);
    }
}

// Invoked when the user is successfully logged in.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController
{
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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"timeOnEnteringBackground"];
    [defaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *timeOnEnteringBackground = [defaults objectForKey:@"timeOnEnteringBackground"];
    
    for (WS_JobTaskAllocation *jta in self.sharedModel.taskAllocations) {
        if (jta.timesheet && jta.timesheet.isRecordingTime) {
            jta.timesheet.timeElapsedInterval = jta.timesheet.timeElapsedInterval + [[NSDate date] timeIntervalSinceDate:timeOnEnteringBackground];
        }
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

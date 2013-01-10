//
//  CommandLibrary.m
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import "ServiceCommandLibrary.h"
#import "LoadClientCompanies.h"
#import "LoadJobsCommand.h"
#import "GlobalModel.h"

@implementation ServiceCommandLibrary

+(void)loadClientsWithParams:(NSDictionary*)params{
//    [LoadClientCompanies execute];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/crm/client"]
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* clients = [mappingResult array];
                                NSLog(@"Loaded clients: %@", clients);
                                sharedModel.clients = [[NSMutableArray alloc]initWithArray:clients];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

+(void)loadJobsWithParams:(NSDictionary*)params{
//    [LoadJobsCommand execute];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/job"]
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* jobs = [mappingResult array];
                                NSLog(@"Loaded jobs: %@", jobs);
                                sharedModel.jobs = [[NSMutableArray alloc]initWithArray:jobs];
                                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

+(void)loadJobDetailsWithParams:(NSDictionary*)params{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/jobdetail"]
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* jobDetails = [mappingResult array];
                                NSLog(@"Loaded job details: %@", jobDetails);
                                sharedModel.jobDetails = [[NSMutableArray alloc]initWithArray:jobDetails];
                                           }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

+(void)loadJobTaskAllocationsWithParams:(NSDictionary*)params{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/staff/employee/%@/jobtaskallocations",sharedModel.loggedInEmployee.trafficEmployeeId]
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* jtas = [mappingResult array];
                                NSMutableArray *mutableJtas = [[NSMutableArray alloc]init];
                                for (WS_JobTaskAllocation *jta in jtas) {
                                    if ([jta isKindOfClass:[WS_JobTaskAllocation class]]) {
                                        [mutableJtas addObject:jta];
                                    }
                                }
                                sharedModel.taskAllocations = mutableJtas;
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

+(void)loadProjectsWithParams:(NSDictionary*)params{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/TrafficLiteServer/openapi/project"]
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* projects = [mappingResult array];
                                sharedModel.projects = [[NSMutableArray alloc]initWithArray:projects];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}

@end

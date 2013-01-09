//
//  CommandLibrary.m
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import "ServiceCommandLibrary.h"
#import "LoadClientCompanies.h"
#import "LoadJobTaskAllocationsCommand.h"
#import "LoadJobsCommand.h"

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
                                NSMutableDictionary *clientDict = [[NSMutableDictionary alloc]init];
                                
                                if([clients count] > 0)
                                {
                                    for (WS_Client *client in clients) {
                                        [clientDict setObject:client forKey:client.clientId.stringValue];
                                    }
                                    sharedModel.clients = [[NSMutableArray alloc]initWithArray:clients];
                                    sharedModel.clientsDictionary = clientDict;
                                    //Store result offline:
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:clientDict ] forKey:kClientsStoreKey];
                                }
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
                                NSMutableDictionary *jobDict = [[NSMutableDictionary alloc]init];
                                
                                if([jobs count] > 0)
                                {
                                    for (WS_Job *job in jobs) {
                                        [jobDict setObject:job forKey:job.jobId.stringValue];
                                    }
                                    sharedModel.jobs = [[NSMutableArray alloc]initWithArray:jobs];
                                    sharedModel.jobsDictionary = jobDict;
                                    //Store result offline:
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:jobDict] forKey:kJobsStoreKey];
                                }
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
                                NSMutableDictionary *jdDict = [[NSMutableDictionary alloc]init];
                                
                                if([jobDetails count] > 0)
                                {
                                    for (WS_JobDetail *jd in jobDetails) {
                                        [jdDict setObject:jd forKey:jd.jobDetailId.stringValue];
                                    }
                                    sharedModel.jobDetails = [[NSMutableArray alloc]initWithArray:jobDetails];
                                    sharedModel.jobDetailsDictionary = jdDict;
                                    //Store result offline:
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:jdDict] forKey:kJobDetailsStoreKey];
                                }
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
                                NSMutableDictionary *projectsDict = [[NSMutableDictionary alloc]init];
                                if([projects count] > 0){
                                    for (WS_Project *proj in projects) {
                                        [projectsDict setObject:proj forKey:proj.projectId.stringValue];
                                    }
                                }
                                sharedModel.projects = [[NSMutableArray alloc]initWithArray:projects];
                                sharedModel.projectsDictionary = projectsDict;
                                //Store result offline:
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:projectsDict] forKey:kProjectsStoreKey];
                                
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

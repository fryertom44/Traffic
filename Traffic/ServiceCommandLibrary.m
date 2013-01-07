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
    [LoadClientCompanies execute];
}
+(void)loadJobsWithParams:(NSDictionary*)params{
    [LoadJobsCommand execute];
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
//                                NSLog(@"Loaded job task allocations: %@", [jtas description]);
                                NSMutableArray *mutableJtas = [[NSMutableArray alloc]init];
                                for (WS_JobTaskAllocation *jta in jtas) {
                                    [mutableJtas addObject:jta];
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
                                NSLog(@"Loaded projects: %@", projects);
                                if([projects count] > 0){
                                    for (WS_Project *proj in projects) {
                                        [projectsDict setObject:proj forKey:proj.projectId.stringValue];
                                    }
                                }
                                sharedModel.projects = [[NSMutableArray alloc]initWithArray:projects];
                                sharedModel.projectsDictionary = projectsDict;
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

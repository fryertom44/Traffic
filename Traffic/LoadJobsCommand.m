//
//  LoadJobsCommand.m
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import "LoadJobsCommand.h"
#import "GlobalModel.h"
#import <RestKit.h>

@implementation LoadJobsCommand

+(void)execute{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:@"/TrafficLiteServer/openapi/job"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* jobs = [mappingResult array];
                                NSLog(@"Loaded jobs: %@", jobs);
                                NSMutableDictionary* jobsDict = [[NSMutableDictionary alloc]init];
                                NSMutableDictionary* jobTasksDict = [[NSMutableDictionary alloc]init];
                                for (WS_Job* job in jobs) {
                                    [jobsDict setObject:job forKey:job.jobId.stringValue];
                                    for (WS_JobTask* jt in job.jobTasks) {
                                        [jobTasksDict setObject:jt forKey:jt.jobTaskId.stringValue];
                                    }
                                }
                                sharedModel.jobsDictionary = jobsDict;
                                sharedModel.jobTasksDictionary = jobTasksDict;
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
@end

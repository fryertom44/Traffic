//
//  GlobalModel.m
//  Traffic
//
//  Created by Tom Fryer on 04/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "GlobalModel.h"
#import "WS_JobTaskAllocation.h"

@implementation GlobalModel

static GlobalModel *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (GlobalModel *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        self.pageNumber=1;
    }
    
    return self;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)printOutTaskAllocations{
    for (WS_JobTaskAllocation *jt in self.taskAllocations) {
        NSLog(@"Task Allocation:%@",jt);
        NSLog(@"%@:%@", @"description", jt.taskDescription);
        NSLog(@"%@:%@", @"happyRating", jt.happyRating);
        NSLog(@"%@:%@", @"isTaskComplete", jt.isTaskComplete);
        NSLog(@"%@:%@", @"taskDeadline", jt.taskDeadline);

    }
}

#pragma mark - overwritten setters

-(void)setClients:(NSMutableArray *)clients{
    if (_clients != clients)
    {
        _clients = clients;
        
        if([_clients count] > 0)
        {
            NSMutableDictionary *clientDict = [[NSMutableDictionary alloc]init];
            
            for (WS_Client *client in _clients) {
                [clientDict setObject:client forKey:client.clientId.stringValue];
            }
            _clientsDictionary = clientDict;
            //Store result offline:
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_clients] forKey:kClientsStoreKey];
        }
    }
}

-(void)setJobs:(NSMutableArray *)jobs{
    if (_jobs != jobs) {
        _jobs = jobs;
        
        if([_jobs count] > 0)
        {
            NSMutableDictionary *jobDict = [[NSMutableDictionary alloc]init];

            for (WS_Job *job in _jobs) {
                [jobDict setObject:job forKey:job.jobId.stringValue];
            }
            _jobsDictionary = jobDict;
            //Store result offline:
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_jobs] forKey:kJobsStoreKey];
        }
    }
}

-(void)setProjects:(NSMutableArray *)projects{
    if (_projects != projects) {
        _projects = projects;
        
        if([_projects count] > 0){
            NSMutableDictionary *projectsDict = [[NSMutableDictionary alloc]init];

            for (WS_Project *proj in _projects) {
                [projectsDict setObject:proj forKey:proj.projectId.stringValue];
            }
            
            _projectsDictionary = projectsDict;
            //Store result offline:
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_projects] forKey:kProjectsStoreKey];
        }
    }
}

-(void)setJobDetails:(NSMutableArray *)jobDetails{
    if (_jobDetails != jobDetails) {
        _jobDetails = jobDetails;
        
        if([_jobDetails count] > 0)
        {
            NSMutableDictionary *jdDict = [[NSMutableDictionary alloc]init];

            for (WS_JobDetail *jd in _jobDetails) {
                [jdDict setObject:jd forKey:jd.jobDetailId.stringValue];
            }
            _jobDetailsDictionary = jdDict;
            //Store result offline:
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_jobDetails] forKey:kJobDetailsStoreKey];
        }
    }
}

-(void)setTaskAllocations:(NSMutableArray *)taskAllocations{
    if(_taskAllocations != taskAllocations){
        _taskAllocations = taskAllocations;
        
        if ([_taskAllocations count] > 0) {
            NSMutableDictionary* allocationsDict = [[NSMutableDictionary alloc]init];
            
            for (WS_JobTaskAllocation* jta in _taskAllocations) {
                [allocationsDict setObject:jta forKey:jta.jobTaskAllocationGroupId.stringValue];
            }
            _jobTaskAllocationsDictionary = allocationsDict;
        }
    }
}

@end

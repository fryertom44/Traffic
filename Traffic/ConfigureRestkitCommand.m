//
//  ConfigureRestkit.m
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import "ConfigureRestkitCommand.h"
#import "WS_Client.h"
#import "GlobalModel.h"
#import "KeychainItemWrapper.h"
#import "WS_AllocationInterval.h"

@implementation ConfigureRestkitCommand

+(void)execute{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"TrafficLogin" accessGroup:nil];
    NSString* email = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString* apiKey = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.sohnar.com/TrafficLiteServer/openapi"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    [client setAuthorizationHeaderWithUsername:email password:apiKey];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup our object mappings
    
    RKObjectMapping *moneyMapping = [RKObjectMapping mappingForClass:[Money class]];
    [moneyMapping addAttributeMappingsFromDictionary:@{
     @"amountString" : @"amount",
     @"currencyType" : @"currencyType",
     }];
    
    RKObjectMapping *clientMapping = [RKObjectMapping mappingForClass:[WS_Client class]];
    [clientMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"clientId",
     @"name" : @"clientName",
     }];

    RKObjectMapping *jobTaskMapping = [RKObjectMapping mappingForClass:[WS_JobTask class]];
    [jobTaskMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"jobTaskId",
     @"version" : @"version",
     @"description" : @"jobTaskDescription",
     @"internalNote" : @"internalNote",
     @"quantity" : @"quantity",
     @"chargeBandId.id" : @"chargeBandId",
     @"jobId" : @"jobId",
     @"jobTaskCompletionDate" : @"jobTaskCompletionDate",
     @"studioAllocationMinutes" : @"studioAllocationMinutes",
     @"taskDeadline" : @"taskDeadline",
     @"taskStartDate" : @"taskStartDate",
     @"jobStageDescription" : @"jobStageDescription",
     @"durationMinutes" : @"durationMinutes",
     @"totalTimeLoggedMinutes" : @"totalTimeLoggedMinutes",
     @"totalTimeLoggedBillableMinutes" : @"totalTimeLoggedBillableMinutes",
     @"totalTimeAllocatedMinutes" : @"totalTimeAllocatedMinutes",
     }];
    [jobTaskMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cost" toKeyPath:@"cost" withMapping:moneyMapping]];
    [jobTaskMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rate" toKeyPath:@"rate" withMapping:moneyMapping]];
    [jobTaskMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rateOtherCurrency" toKeyPath:@"rateOtherCurrency" withMapping:moneyMapping]];
    [jobTaskMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"billableNet" toKeyPath:@"billableNet" withMapping:moneyMapping]];
    
    RKObjectMapping *jobDetailMapping = [RKObjectMapping mappingForClass:[WS_JobDetail class]];
    [jobDetailMapping addAttributeMappingsFromDictionary:@{
     @"jobId" : @"jobId",
     @"id" : @"jobDetailId",
     @"description" : @"jobDescription",
     @"name" : @"jobTitle",
     @"accountManagerId" : @"accountManagerId",
     @"ownerProjectId" : @"ownerProjectId",
     }];

    RKObjectMapping *jobMapping = [RKObjectMapping mappingForClass:[WS_Job class]];
    [jobMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"jobId",
     @"jobDetailId" : @"jobDetailId",
     @"internalDeadline" : @"jobDeadline",
     @"jobNumber" : @"jobNumber",
     }];
    [jobMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"jobTasks" toKeyPath:@"jobTasks" withMapping:jobTaskMapping]];
    
    RKObjectMapping *allocationIntervalMapping = [RKObjectMapping mappingForClass:[WS_AllocationInterval class]];
    [allocationIntervalMapping addAttributeMappingsFromDictionary:@{
     @"startTime" : @"startTime",
     @"endTime" : @"endTime",
     @"allocationIntevalStatus" : @"allocationIntervalStatus",
     @"durationInSeconds" : @"durationInSeconds",
     @"dateModified" : @"dateModified",
     @"uuid" : @"uuid",
     @"version" : @"wsVersion",
     @"class" : @"className"
     }];
    
    RKObjectMapping *jobTaskAllocationMapping = [RKObjectMapping mappingForClass:[WS_JobTaskAllocation class]];
    [jobTaskAllocationMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"jobTaskAllocationGroupId",
     @"jobId" : @"jobId",
     @"description" : @"taskDescription",
     @"happyRating" : @"happyRating",
     @"isTaskComplete" : @"isTaskComplete",
     @"taskDeadline" : @"taskDeadline",
     @"jobTaskId.id" : @"jobTaskId",
     @"trafficEmployeeId.id" : @"trafficEmployeeId",
     @"internalNote" : @"internalNote",
     @"externalCalendarTag" : @"externalCalendarTag",
     @"externalCalendarUuid" : @"externalCalendarUUID",
     @"durationInMinutes" : @"durationInMinutes",
     @"dependancyTaskDeadline" : @"dependencyTaskDeadline",
     @"jobStageDescription" : @"jobStageDescription",
     @"jobStageUuid" : @"JobStageUUID",
     @"totalTimeLoggedMinutes" : @"totalTimeLoggedMinutes",
     @"isTaskMilesone" : @"isTaskMilestone",
     @"uuid" : @"uuid",
     @"version" : @"wsVersion",
     }];
    
    [jobTaskAllocationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"allocationIntervals" toKeyPath:@"allocationIntervals" withMapping:allocationIntervalMapping]];
    
    RKObjectMapping *trafficEmployeeMapping = [RKObjectMapping mappingForClass:[WS_TrafficEmployee class]];
    [trafficEmployeeMapping addAttributeMappingsFromDictionary:@{
     @"employeeDetails.personalDetails.firstName" : @"firstName",
          @"employeeDetails.personalDetails.lastName" : @"lastName",
     }];
    [trafficEmployeeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"employeeDetails.costPerHour" toKeyPath:@"costPerHour" withMapping:trafficEmployeeMapping]];

    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[WS_Project class]];
    [projectMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"projectId",
     @"name" : @"projectName",
     @"clientCRMEntryId" : @"clientCRMEntryId",
     }];
    
    // Update date format so that we can parse JSON dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:kJSONDateFormat inTimeZone:nil];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *clientsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping
                                                                                       pathPattern:@"crm/client"
                                                                                           keyPath:@"resultList"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping
                                                                                             pathPattern:@"job"
                                                                                                 keyPath:@"resultList"
                                                                                             statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping
                                                                                           pathPattern:@"jobdetail"
                                                                                               keyPath:@"resultList"
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping
                                                                                                             pathPattern:@"timeallocations/jobtasks"
                                                                                                                 keyPath:@"resultList"
                                                                                                             statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationByEmployeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping
                                                                                                pathPattern:@"staff/employee/:trafficEmployeeId/jobtaskallocations"
                                                                                                    keyPath:@"resultList"
                                                                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationByJobResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping
                                                                                                                  pathPattern:@"job/:jobId/jobtaskallocations"
                                                                                                                      keyPath:@"resultList"
                                                                                                                  statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:clientsResponseDescriptor];
    [objectManager addResponseDescriptor:jobsResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationByEmployeeResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationByJobResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeeResponseDescriptor];
    [objectManager addResponseDescriptor:projectResponseDescriptor];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"/crm/client/:clientId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"/crm/client"
                                             method:RKRequestMethodPUT]];

    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"/crm/client/:clientId"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"/crm/client/:clientId"
                                             method:RKRequestMethodDELETE]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"/job"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"/job"
                                             method:RKRequestMethodPUT]];

    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"/job/:jobId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"/jobdetail/:jobDetailId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"/jobdetail"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"/jobdetail"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"/timeallocations/jobtasks"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"/timeallocations/jobtasks"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"/timeallocations/jobtasks/:jobTaskAllocationGroupId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"/project/:projectId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"/project"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"/project"
                                             method:RKRequestMethodPUT]];

}

@end

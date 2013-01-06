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
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    //    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

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
    [client setParameterEncoding:AFJSONParameterEncoding];
    
    [client setAuthorizationHeaderWithUsername:email password:apiKey];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Update date format so that we can parse JSON dates properly
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = kJSONDateFormat;
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [RKObjectMapping addDefaultDateFormatter:df];
    [RKObjectMapping setPreferredDateFormatter:df];
    
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
     @"allocationIntervalStatus" : @"allocationIntervalStatus",
     @"durationInSeconds" : @"durationInSeconds",
     @"dateModified" : @"dateModified",
     @"uuid" : @"uuid",
     @"version" : @"trafficVersion",
     @"class" : @"className"
     }];
    
    RKObjectMapping *jobTaskAllocationMapping = [RKObjectMapping mappingForClass:[WS_JobTaskAllocation class]];
    [jobTaskAllocationMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"jobTaskAllocationGroupId",
     @"jobId.id" : @"jobId",
     @"description" : @"taskDescription",
     @"happyRating" : @"happyRating",
     @"isTaskComplete" : @"isTaskComplete",
     @"taskDeadline" : @"taskDeadline",
     @"jobTaskId.id" : @"jobTaskId",
     @"trafficEmployeeId.id" : @"trafficEmployeeId",
     @"externalCalendarTag" : @"externalCalendarTag",
     @"externalCalendarUUID" : @"externalCalendarUUID",
     @"durationInMinutes" : @"durationInMinutes",
     @"dependancyTaskDeadline" : @"dependencyTaskDeadline",
     @"jobStageDescription" : @"jobStageDescription",
     @"jobStageUUID" : @"jobStageUUID",
     @"totalTimeLoggedMinutes" : @"totalTimeLoggedMinutes",
     @"isTaskMilesone" : @"isTaskMilestone",
     @"uuid" : @"uuid",
     @"version" : @"trafficVersion",
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
    
    RKObjectMapping *timeEntryMapping = [RKObjectMapping mappingForClass:[WS_TimeEntry class]];
    [timeEntryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"timeEntryId",
     @"jobId.id" : @"jobId",
     @"allocationGroupId.id" : @"jobTaskAllocationGroupId",
     @"jobStageDescription" : @"jobStageDescription",
     @"jobTaskId.id" : @"jobTaskId",
     @"lockedByApproval" : @"lockedByApproval",
     @"minutes" : @"minutes",
     @"taskDescription" : @"taskDescription",
     @"trafficEmployeeId.id" : @"trafficEmployeeId",
     @"billable" : @"billable",
     @"version" : @"trafficVersion",
     @"chargeBandId.id" : @"chargeBandId",
     @"comment" : @"comment",
     @"exported" : @"exported",
     @"endTime" : @"endTime",
     @"workPoints" : @"workPoints",
     @"startTime" : @"startTime",
     @"taskComplete" : @"isTaskComplete",
     @"lockedByApprovalDate" : @"lockedByApprovalDate",
     @"lockedByApprovalEmployeeId" : @"lockedByApprovalEmployeeId",
     @"exportError" : @"exportError",
     }];
    
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"timeEntryCost" toKeyPath:@"timeEntryCost" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"timeEntryPersonalRate" toKeyPath:@"timeEntryPersonalRate" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"valueOfTimeEntry" toKeyPath:@"valueOfTimeEntry" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"taskRate" toKeyPath:@"taskRate" withMapping:moneyMapping]];

    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *clientsGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping pathPattern:@"crm/client" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *clientsPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping pathPattern:@"crm/client" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobsGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping pathPattern:@"job" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
//    RKResponseDescriptor *jobsPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping pathPattern:@"job" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping                                                                                            pathPattern:@"jobdetail" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping                                                                                            pathPattern:@"jobdetail" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"timeallocations/jobtasks" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"timeallocations/jobtasks" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationByEmployeeGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"staff/employee/:trafficEmployeeId/jobtaskallocations" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationByJobGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"job/:jobId/jobtaskallocations" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeeGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeePutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *timeEntryGetResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeEntryMapping pathPattern:@"timeentries" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *timeEntryPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeEntryMapping pathPattern:@"timeentries" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];

    [objectManager addResponseDescriptor:clientsGetResponseDescriptor];
    [objectManager addResponseDescriptor:clientsPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobsGetResponseDescriptor];
//    [objectManager addResponseDescriptor:jobsPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailGetResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationGetResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationByEmployeeGetResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationByJobGetResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeeGetResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeePutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:projectGetResponseDescriptor];
    [objectManager addResponseDescriptor:projectPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:timeEntryGetResponseDescriptor];
    [objectManager addResponseDescriptor:timeEntryPutPostDeleteResponseDescriptor];

    //Register our request mapping (for PUT, POST and DELETE actions)
    RKRequestDescriptor *timeEntryRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[timeEntryMapping inverseMapping] objectClass:[WS_TimeEntry class] rootKeyPath:nil];
    
    RKRequestDescriptor *jobTaskAllocationRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[jobTaskAllocationMapping inverseMapping] objectClass:[WS_JobTaskAllocation class] rootKeyPath:nil];

    RKRequestDescriptor *clientRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[clientMapping inverseMapping] objectClass:[WS_Client class] rootKeyPath:nil];
    
    RKRequestDescriptor *projectRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[projectMapping inverseMapping] objectClass:[WS_Project class] rootKeyPath:nil];
    
    RKRequestDescriptor *jobRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[jobMapping inverseMapping] objectClass:[WS_Job class] rootKeyPath:nil];
    
    RKRequestDescriptor *jobDetailRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[jobDetailMapping inverseMapping] objectClass:[WS_JobDetail class] rootKeyPath:nil];
    
    [objectManager addRequestDescriptor:timeEntryRequestDescriptor];
    [objectManager addRequestDescriptor:jobTaskAllocationRequestDescriptor];
    [objectManager addRequestDescriptor:clientRequestDescriptor];
    [objectManager addRequestDescriptor:projectRequestDescriptor];
    [objectManager addRequestDescriptor:jobRequestDescriptor];
    [objectManager addRequestDescriptor:jobDetailRequestDescriptor];
    
    //Routing
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"crm/client/:clientId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"crm/client"
                                             method:RKRequestMethodPUT]];

    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Client class]
                                             pathPattern:@"crm/client"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"job"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"job"
                                             method:RKRequestMethodPUT]];

    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Job class]
                                             pathPattern:@"job/:jobId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"jobdetail/:jobDetailId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"jobdetail"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobDetail class]
                                             pathPattern:@"jobdetail"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"timeallocations/jobtasks"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"timeallocations/jobtasks"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_JobTaskAllocation class]
                                             pathPattern:@"timeallocations/jobtasks/:jobTaskAllocationGroupId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"project/:projectId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"project"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_Project class]
                                             pathPattern:@"project"
                                             method:RKRequestMethodPUT]];

    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TimeEntry class]
                                             pathPattern:@"timeentries"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TimeEntry class]
                                             pathPattern:@"timeentries"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TimeEntry class]
                                             pathPattern:@"timeentries/:timeEntryId"
                                             method:RKRequestMethodGET]];
}

@end

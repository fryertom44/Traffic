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
    
#pragma mark - Object Mapping
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
     @"notes" : @"notes",
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
     @"taskDescription" : @"taskDescription",
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
     @"id" : @"trafficEmployeeId",
     @"employeeDetails.personalDetails.firstName" : @"firstName",
     @"employeeDetails.personalDetails.lastName" : @"lastName",
     @"version" : @"trafficVersion",
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
//     @"workPoints" : @"workPoints",
     @"startTime" : @"startTime",
     @"taskComplete" : @"isTaskComplete",
     @"lockedByApprovalDate" : @"lockedByApprovalDate",
     @"lockedByApprovalEmployeeId" : @"lockedByApprovalEmployeeId",
     }];
    
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"timeEntryCost" toKeyPath:@"timeEntryCost" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"timeEntryPersonalRate" toKeyPath:@"timeEntryPersonalRate" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"valueOfTimeEntry" toKeyPath:@"valueOfTimeEntry" withMapping:moneyMapping]];
    [timeEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"taskRate" toKeyPath:@"taskRate" withMapping:moneyMapping]];

    
#pragma mark - Response Mapping
    RKResponseDescriptor *clientsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping pathPattern:@"crm/client" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *clientResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping pathPattern:@"crm/client/:clientId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *clientPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping pathPattern:@"crm/client" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping pathPattern:@"job" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping pathPattern:@"job/:jobId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping pathPattern:@"job" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping                                                                                            pathPattern:@"jobdetail" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping                                                                                            pathPattern:@"jobdetail/:jobDetailId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobDetailPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobDetailMapping                                                                                            pathPattern:@"jobdetail" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"timeallocations/jobtasks" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"timeallocations/jobtasks/:jobTaskAllocationGroupId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"timeallocations/jobtasks" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];

    RKResponseDescriptor *jobTaskAllocationsByEmployeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"staff/employee/:trafficEmployeeId/jobtaskallocations" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *jobTaskAllocationsByJobResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobTaskAllocationMapping pathPattern:@"job/:jobId/jobtaskallocations" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee/:trafficEmployeeId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *trafficEmployeePutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trafficEmployeeMapping pathPattern:@"staff/employee" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project/:projectId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *projectPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:projectMapping pathPattern:@"project" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *timeEntriesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeEntryMapping pathPattern:@"timeentries" keyPath:@"resultList" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *timeEntryResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeEntryMapping pathPattern:@"timeentries/:timeEntryId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *timeEntryPutPostDeleteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:timeEntryMapping pathPattern:@"timeentries" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];

    [objectManager addResponseDescriptor:clientsResponseDescriptor];
    [objectManager addResponseDescriptor:clientResponseDescriptor];
    [objectManager addResponseDescriptor:clientPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobsResponseDescriptor];
    [objectManager addResponseDescriptor:jobResponseDescriptor];
//    [objectManager addResponseDescriptor:jobsPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailsResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailResponseDescriptor];
    [objectManager addResponseDescriptor:jobDetailPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationsResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationsByEmployeeResponseDescriptor];
    [objectManager addResponseDescriptor:jobTaskAllocationsByJobResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeeResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeesResponseDescriptor];
    [objectManager addResponseDescriptor:trafficEmployeePutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:projectResponseDescriptor];
    [objectManager addResponseDescriptor:projectsResponseDescriptor];
    [objectManager addResponseDescriptor:projectPutPostDeleteResponseDescriptor];
    [objectManager addResponseDescriptor:timeEntriesResponseDescriptor];
    [objectManager addResponseDescriptor:timeEntryResponseDescriptor];
    [objectManager addResponseDescriptor:timeEntryPutPostDeleteResponseDescriptor];

#pragma mark - Request Mapping

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
    
    
#pragma mark - Routing
    
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
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TrafficEmployee class]
                                             pathPattern:@"staff/employee/:trafficEmployeeId"
                                             method:RKRequestMethodGET]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TrafficEmployee class]
                                             pathPattern:@"staff/employee"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[WS_TrafficEmployee class]
                                             pathPattern:@"staff/employee"
                                             method:RKRequestMethodPOST]];
}

@end

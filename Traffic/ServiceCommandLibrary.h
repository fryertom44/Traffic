//
//  CommandLibrary.h
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceCommandLibrary : NSObject

+(void)loadClientsWithParams:(NSDictionary*)params;
+(void)loadJobsWithParams:(NSDictionary*)params;
+(void)loadJobTaskAllocationsWithParams:(NSDictionary*)params;
+(void)loadJobDetailsWithParams:(NSDictionary*)params;
+(void)loadProjectsWithParams:(NSDictionary*)params;
+(void)loadEmployeesWithParams:(NSDictionary*)params;

@end

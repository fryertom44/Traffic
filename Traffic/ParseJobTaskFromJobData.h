//
//  ParseJobTask.h
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WS_JobTask.h"

@class WS_JobTask;

@interface ParseJobTaskFromJobData : NSObject

+(WS_JobTask*)parseData:(NSData *)data fetchJobTaskWithId:(NSNumber*)jobTaskId;

@end

//
//  LoadJobCommand.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadJobCommand : NSObject

@property (nonatomic, retain) NSMutableData *responseData;

- (void)executeWithJobId:(NSNumber*)jobId;

@end

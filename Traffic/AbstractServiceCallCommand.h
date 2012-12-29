//
//  AbstractServiceCallCommand.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalModel.h"

@interface AbstractServiceCallCommand : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *responseData;
@property (readonly) GlobalModel *sharedModel;

- (NSString*)jsonTimeFormatString;
- (GlobalModel*)sharedModel;
- (Money*)newMoneyFromDict:(NSDictionary*)dict;
@end

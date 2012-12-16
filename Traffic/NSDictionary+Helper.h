//
//  NSDictionary+Helper.h
//  Traffic
//
//  Created by Tom Fryer on 15/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

- (NSString *)getStringUsingkey:(id)key fallback:(NSString*)fallback;

@end

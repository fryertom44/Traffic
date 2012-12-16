//
//  NSDictionary+Helper.m
//  Traffic
//
//  Created by Tom Fryer on 15/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

- (NSString *)getStringUsingkey:(id)key fallback:(NSString*)fallback {
    id result = [self objectForKey: key];
    
    if (!result)
        result = fallback;
    else if (![result isKindOfClass: [NSString class]])
        result = [result description];
    
    return result;
}

@end

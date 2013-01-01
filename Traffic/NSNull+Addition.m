//
//  NSNull+Addition.m
//  Traffic
//
//  Created by Tom Fryer on 31/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "NSNull+Addition.h"

@implementation NSNull (Addition)

+ (id)nullWhenNil:(id)obj {
    
    return (obj ? obj : [self null]);
    
}

@end

//
//  ParserJobTask.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserJobTaskAllocation : NSObject

+ (NSMutableArray*)parseData:(NSData*)data;
@end

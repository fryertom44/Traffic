//
//  Money.h
//  traffic
//
//  Created by Tom Fryer on 15/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Money : NSDecimalNumber {
	NSString* amount;
	NSString* currencyType;
}

@property (nonatomic, retain) NSString* amount;
@property (nonatomic, retain) NSString* currencyType;

+ (Money *)initWithAmount:(NSDecimalNumber *)amount currencyType:(NSString *)currencyType;

@end

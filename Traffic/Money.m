//
//  Money.m
//  traffic
//
//  Created by Tom Fryer on 15/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Money.h"


@implementation Money

@synthesize currencyType,amount;

-(id)init{
    self = [super init];
    if(self){
        self.amount = [NSNumber numberWithFloat:0.00];
        self.currencyType = @"GBP";
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
	self = [[Money alloc] init];
    if (self != nil)
	{
		self.amount = [coder decodeObjectForKey:@"amount"];
		self.currencyType = [coder decodeObjectForKey:@"currencyType"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:self.amount forKey:@"amount"];
	[coder encodeObject:self.currencyType forKey:@"currencyType"];

    
}
@end

//
//  ParserTimeEntry.h
//  traffic
//
//  Created by Tom Fryer on 15/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParserTimeEntry : NSObject {
	
	NSMutableString* currentElementValue;
}

//- (ParserTimeEntry *) initParser;
+ (void)parseData:(NSData*)data;
@end
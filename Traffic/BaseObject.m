//
//  BaseObject.m
//  Traffic
//
//  Created by Tom Fryer on 21/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"
#import "objc/runtime.h"

@implementation BaseObject

//@synthesize memento;

- (void)saveState {
    memento = [self copy];
}

- (void)restoreState {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList( memento, &count );
    for( unsigned int i = 0; i < count; i++ ) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSStringEncodingConversionAllowLossy];
        id propertyValue = [self valueForKey:propertyName];
        NSLog( @"property: %@", propertyName );

        [self setValue:propertyValue forKeyPath:propertyName];
    }
    free( properties );
}

#pragma mark - NSCopying protocol implementation

-(id)copyWithZone:(NSZone *)zone
{
    NSLog(@"copyWithZone must be implemented in subclass");
    return nil;
}
@end

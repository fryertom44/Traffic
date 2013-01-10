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

-(id)init{
    self = [super init];
    if (self) {
        self.trafficVersion = [NSNumber numberWithInteger:-1];
    }
    return self;
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

-(BOOL)isUnsaved{
    return self.trafficVersion == [NSNumber numberWithInteger:-1];
}

// prints out list of objects properties (FOR DEBUGGING USE ONLY)
//- (NSString *)description
//{
//    NSMutableString *string = [NSMutableString stringWithString:@""];
//    unsigned int propertyCount;
//    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
//    
//    for (unsigned int i = 0; i < propertyCount; i++)
//    {
//        NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
//        
//        SEL sel = sel_registerName([selector UTF8String]);
//        
//        const char *attr = property_getAttributes(properties[i]);
//        switch (attr[1]) {
//            case '@':
//                [string appendString:[NSString stringWithFormat:@"%s : %@\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
//                break;
//            case 'i':
//                [string appendString:[NSString stringWithFormat:@"%s : %i\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
//                break;
//            case 'f':
//                [string appendString:[NSString stringWithFormat:@"%s : %f\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
//                break;
//            default:
//                break;
//        }
//    }
//    
//    free(properties);
//    
//    return string;
//    
//}

@end

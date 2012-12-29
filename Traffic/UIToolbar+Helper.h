//
//  UIToolbar+Helper.h
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Helper)

+(UIToolbar *)newKeyboardViewWithDoneMethod:(SEL)doneMethod
                                cancelMethod:(SEL)cancelMethod
                                forComponent:(id)component;
@end

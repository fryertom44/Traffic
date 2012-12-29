//
//  UIToolbar+Helper.m
//  Traffic
//
//  Created by Tom Fryer on 23/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "UIToolbar+Helper.h"

@implementation UIToolbar (Helper)

+(UIToolbar *)newKeyboardViewWithDoneMethod:(SEL)doneMethod cancelMethod:(SEL)cancelMethod forComponent:(id)component
{
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleBordered target:self
                                                                    action:cancelMethod];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:doneMethod];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,cancelButton,doneButton, nil]];
    return keyboardDoneButtonView;
}

@end

//
//  DatePickerWithToolBar.m
//  Traffic
//
//  Created by Tom Fryer on 29/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "DatePickerWithToolBar.h"

@implementation DatePickerWithToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)doneClicked:(id)sender {
    [self.delegate doneClickedOnPicker:self.datePicker forComponent:self.textField];
}

- (IBAction)cancelClicked:(id)sender {
    [self.delegate cancelClickedOnPicker:self.datePicker forComponent:self.textField];
}

@end

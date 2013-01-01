//
//  DatePickerWithToolBar.h
//  Traffic
//
//  Created by Tom Fryer on 29/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerWithToolBarDelegate <NSObject>
// Invoked after a login attempt completes.
-(void)doneClickedOnPicker:(UIDatePicker*)datePicker forComponent:(UITextField*)textField;
-(void)cancelClickedOnPicker:(UIDatePicker*)datePicker forComponent:(UITextField*)textField;
@end

@interface DatePickerWithToolBar : UIView

@property (nonatomic, assign) id<DatePickerWithToolBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,retain) UITextField *textField;

- (IBAction)doneClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

@end

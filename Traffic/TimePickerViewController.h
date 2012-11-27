//
//  TimePickerViewController.h
//  Traffic
//
//  Created by Tom Fryer on 25/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
- (IBAction)onOkSelected:(id)sender;
- (IBAction)onCancelSelected:(id)sender;

@end

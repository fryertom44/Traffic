//
//  PGToggleButton.h
//  Traffic
//
//  Created by Tom Fryer on 20/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGToggleButton : UIButton

@property (nonatomic, strong) UIImage *offStateImage;
@property (nonatomic, strong) UIImage *onStateImage;
@property (nonatomic, getter=isOn) BOOL on;

-(void)touchedUpInside:(UIButton*) sender;
-(void)toggle;

@end
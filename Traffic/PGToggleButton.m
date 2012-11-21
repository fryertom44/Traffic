//
//  PGToggleButton.m
//  Traffic
//
//  Created by Tom Fryer on 20/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "PGToggleButton.h"

@implementation PGToggleButton
@synthesize on = _on;
@synthesize offStateImage = _offStateImage;
@synthesize onStateImage = _onStateImage;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.offStateImage = [self imageForState:UIControlStateNormal];
    self.onStateImage = [self imageForState:UIControlStateHighlighted];
    
    [self addTarget:self
             action:@selector(touchedUpInside:)
   forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchedUpInside:(UIButton*) sender
{
    [self toggle];
}

-(void)toggle
{
    self.on = !_on;
}

-(void)setOn:(BOOL) on
{
    _on = on;
    
    if (on)
        [self setImage:self.onStateImage forState:(UIControlStateNormal)];
    else
        [self setImage:self.offStateImage forState:(UIControlStateNormal)];
}

@end
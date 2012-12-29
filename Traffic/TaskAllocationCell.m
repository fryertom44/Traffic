//
//  TimeEntryCell.m
//  Traffic
//
//  Created by Tom Fryer on 17/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "TaskAllocationCell.h"

@implementation TaskAllocationCell

@synthesize companyLabel;
@synthesize jobLabel;
@synthesize timesheetLabel;
@synthesize timeCompletedLabel;
@synthesize daysToDeadlineLabel;
@synthesize happyRating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

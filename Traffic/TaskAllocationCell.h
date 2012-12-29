//
//  TimeEntryCell.h
//  Traffic
//
//  Created by Tom Fryer on 17/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskAllocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesheetLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysToDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCompletedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *happyRating;

@end

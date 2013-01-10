//
//  TimeEntryCell.m
//  Traffic
//
//  Created by Tom Fryer on 17/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "TaskAllocationCell.h"
#import "NSDate+Helper.h"
#import "HappyRatingHelper.h"

@implementation TaskAllocationCell

@synthesize companyLabel;
@synthesize jobLabel;
@synthesize timesheetLabel;
@synthesize timesheetTime;
@synthesize timeCompletedLabel;
@synthesize daysToDeadlineLabel;
@synthesize happyRating;
@synthesize isRecordingIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    if (isObservingTimesheet) {
        @try {
            [_allocation.timesheet removeObserver:self forKeyPath:@"timeElapsedInterval"];
        }
        @catch (NSException *exception) {
            //Do nothing, because there are no observers to remove
        }
    }
}

- (void)setAllocation:(WS_JobTaskAllocation *)allocation{
    
    if(![_allocation isEqual:allocation]){
        if (isObservingTimesheet) {
            @try {
                [_allocation.timesheet removeObserver:self forKeyPath:@"timeElapsedInterval"];
            }
            @catch (NSException *exception) {
                //Do nothing, because there are no observers to remove
            }
        }
        
        _allocation = allocation;
        
        if (allocation.client) {
            companyLabel.text = [NSString stringWithFormat:@"Company: %@",allocation.client.clientName];
        }
        if(allocation.job && allocation.jobDetail) {
        jobLabel.text = [NSString stringWithFormat:@"Job: %@-%@",allocation.job.jobNumber, allocation.jobDetail.jobTitle];
        }
        
        timesheetLabel.text = _allocation.taskDescription;
        daysToDeadlineLabel.text = [NSString stringWithFormat:@"%d days %@",abs(_allocation.daysUntilDeadline), _allocation.daysUntilDeadline < 0 ? @"overdue" : @"remaining"];
        timeCompletedLabel.text = [NSString stringWithFormat:@"%@ of %@", [NSDate timeStringFromMinutes:_allocation.totalTimeLoggedMinutes.integerValue],[NSDate timeStringFromMinutes:_allocation.durationInMinutes.integerValue]];
        timeCompletedLabel.textColor = _allocation.totalTimeLoggedMinutes.integerValue > _allocation.durationInMinutes.integerValue ? [UIColor redColor] : [UIColor blackColor];
        happyRating.image = [HappyRatingHelper happyRatingImageFromString:_allocation.happyRating];
        
        if(_allocation.timesheet.timeElapsedInterval > 0){
            NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:_allocation.timesheet.timeElapsedInterval];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString=[dateFormatter stringFromDate:timerDate];
            timesheetTime.text = timeString;
            isRecordingIcon.hidden = FALSE;
        }
        else{
            timesheetTime.text = @"";
            isRecordingIcon.hidden = TRUE;
        }
        [_allocation.timesheet addObserver:self forKeyPath:@"timeElapsedInterval" options:NSKeyValueObservingOptionOld context:nil];
        isObservingTimesheet = TRUE;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"timeElapsedInterval"]) {
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:self.allocation.timesheet.timeElapsedInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        NSString *timeString=[dateFormatter stringFromDate:timerDate];
        timesheetTime.text = timeString;
        isRecordingIcon.hidden = FALSE;
    }
}

@end

//
//  Constants.m
//  Traffic
//
//  Created by Tom Fryer on 07/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const kPlayButtonImage = @"play320.png";
NSString *const kStopButtonImage = @"stop320.png";
NSString *const kPauseButtonImage = @"pause320.png";

NSString *const kHappyRatingHappy = @"HAPPY";
NSString *const kHappyRatingSad = @"SAD";
NSString *const kHappyRatingCompleted = @"COMPLETE";

NSString *const kHappyRatingHappyImage = @"happyRatingHappySmall320.png";
NSString *const kHappyRatingSadImage = @"happyRatingSadSmall320.png";
NSString *const kHappyRatingCompletedImage = @"happyRatingCompletedSmall320.png";

NSString *const kJSONDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

#pragma mark - keys for settings
NSString *const kTimeIntervalSettingKey = @"timeInterval";
NSString *const kMaxResultsSettingKey = @"maxAllocationResults";
NSString *const kHideCompletedSettingKey = @"hideCompletedAllocations";
NSString *const kLoginAutomaticallySettingKey = @"loginAutomatically";

#pragma mark - keys for dictionaries of offline-stored data
NSString *const kProjectsStoreKey = @"projectsStore";
NSString *const kJobsStoreKey = @"jobsStore";
NSString *const kClientsStoreKey = @"clientsStore";
NSString *const kJobDetailsStoreKey = @"jobDetailsStore";

@end

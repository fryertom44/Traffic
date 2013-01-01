//
//  HappyRatingHelper.m
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "HappyRatingHelper.h"

@implementation HappyRatingHelper

+(UIImage*)happyRatingImageFromString:(NSString*)happyRating{
    if ([happyRating isEqualToString:kHappyRatingHappy]) {
        return [UIImage imageNamed:kHappyRatingHappyImage];
    }else if ([happyRating isEqualToString:kHappyRatingSad]){
        return [UIImage imageNamed:kHappyRatingSadImage];
    }else if ([happyRating isEqualToString:kHappyRatingCompleted]){
        return [UIImage imageNamed:kHappyRatingCompletedImage];
    }
    return [UIImage imageNamed:kHappyRatingHappyImage];
}

+(NSString*)nextHappyRating:(NSString*)currentRating{
    if ([currentRating isEqualToString:kHappyRatingHappy]) {
        return kHappyRatingSad;
    }else if ([currentRating isEqualToString:kHappyRatingSad]){
        return kHappyRatingCompleted;
    }else if ([currentRating isEqualToString:kHappyRatingCompleted]){
        return kHappyRatingHappy;
    }else{
        return kHappyRatingHappy;
    }
}

@end

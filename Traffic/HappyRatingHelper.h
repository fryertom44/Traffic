//
//  HappyRatingHelper.h
//  Traffic
//
//  Created by Tom Fryer on 30/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HappyRatingHelper : NSObject

+(UIImage*)happyRatingImageFromString:(NSString*)happyRating;
+(NSString*)nextHappyRating:(NSString*)currentRating;

@end

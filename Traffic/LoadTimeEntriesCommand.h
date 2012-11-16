//
//  LoginCommand.h
//  Traffic
//
//  Created by Tom Fryer on 12/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadTimeEntriesCommand : NSObject
{
    NSMutableData *responseData;
    NSMutableArray *timeEntries;
}

@property (nonatomic, retain) NSMutableArray *timeEntries;
@property (nonatomic, retain) NSMutableData *responseData;

@end

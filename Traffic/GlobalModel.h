//
//  GlobalModel.h
//  Traffic
//
//  Created by Tom Fryer on 04/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalModel : NSObject

+ (GlobalModel *)sharedInstance;

@property (nonatomic,strong) NSMutableArray *timeEntries;
@property (nonatomic,strong) NSMutableArray *allocatedTasks;

@end

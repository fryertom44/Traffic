//
//  LoadJobTask.m
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "LoadJobTask.h"
#import "KeychainItemWrapper.h"
#import "GlobalModel.h"
#import "ParseJobTaskFromJobData.h"

@implementation LoadJobTask
@synthesize responseData;

- (void)executeAndUpdateComponent:(id)component{
    GlobalModel *globalModel = [GlobalModel sharedInstance];
    
}

@end

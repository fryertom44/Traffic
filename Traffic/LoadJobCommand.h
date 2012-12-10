//
//  LoadJobCommand.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadJobCommand : NSObject
{
    id componentToUpdate;
}
@property (nonatomic, retain) NSMutableData *responseData;

-(void)executeAndUpdateComponent:(id)sender jobId:(NSNumber*)jobId;

@end

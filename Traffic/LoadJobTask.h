//
//  LoadJobTask.h
//  Traffic
//
//  Created by Tom Fryer on 12/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadJobTask : NSObject
{
    //Whichever component called this command
    id componentToUpdate;
}

@property (nonatomic, retain) NSMutableData *responseData;

-(void)executeAndUpdateComponent:(id)sender page:(int)page;

@end

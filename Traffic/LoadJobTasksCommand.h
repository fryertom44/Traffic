//
//  LoadJobTasksCommand.h
//  Traffic
//
//  Created by Tom Fryer on 05/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadJobTasksCommand : NSObject
{
    //Whichever component called this command
    id componentToUpdate;
}

@property (nonatomic, retain) NSMutableArray *timeEntries;
@property (nonatomic, retain) NSMutableData *responseData;

-(void)executeAndUpdateComponent:(id)sender page:(int)page;

@end

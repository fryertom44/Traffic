//
//  BaseObject.h
//  Traffic
//
//  Created by Tom Fryer on 21/11/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObject : NSObject<NSCopying>
{
    @private
    id memento;
}

//@property (readwrite,nonatomic,retain) id memento;

- (void)saveState;
- (void)restoreState;

@end

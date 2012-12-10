//
//  WS_Client.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_Client : BaseObject
{
    NSNumber*clientId;
    NSString *clientName;
}

@property (nonatomic,retain) NSString *clientName;
@property (nonatomic,retain)NSNumber*clientId;
@end

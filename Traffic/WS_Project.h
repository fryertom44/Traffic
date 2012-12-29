//
//  WS_Project.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_Project : BaseObject

@property (nonatomic,retain) NSString *projectName;
@property NSNumber*clientCRMEntryId;
@property NSNumber*projectId;

@end

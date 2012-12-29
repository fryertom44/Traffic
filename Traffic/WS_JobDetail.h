//
//  WS_JobDetail.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import "BaseObject.h"

@interface WS_JobDetail : BaseObject

@property (nonatomic,retain) NSNumber*jobDetailId;
@property (nonatomic,retain) NSNumber*ownerProjectId;
@property (nonatomic,retain) NSNumber*jobContactId;
@property (nonatomic,retain) NSNumber*accountManagerId;
@property (nonatomic,retain) NSString *jobTitle;
@property (nonatomic,retain) NSString *jobDescription;

@end

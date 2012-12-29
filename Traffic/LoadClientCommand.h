//
//  LoadClient.h
//  Traffic
//
//  Created by Tom Fryer on 09/12/2012.
//  Copyright (c) 2012 Tom Fryer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractServiceCallCommand.h"

@interface LoadClientCommand : AbstractServiceCallCommand

- (void)executeWithClientCRMId:(NSNumber*)clientCRMId;

@end

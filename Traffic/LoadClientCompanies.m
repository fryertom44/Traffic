//
//  LoadClientCompanies.m
//  Traffic
//
//  Created by Tom Fryer on 03/01/2013.
//  Copyright (c) 2013 Tom Fryer. All rights reserved.
//

#import "LoadClientCompanies.h"
#import "WS_Client.h"
#import "GlobalModel.h"
#import <RestKit.h>

@implementation LoadClientCompanies

+(void)execute{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    GlobalModel *sharedModel = [GlobalModel sharedInstance];
    
    [objectManager getObjectsAtPath:@"/TrafficLiteServer/openapi/crm/client"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* clients = [mappingResult array];
                                NSLog(@"Loaded clients: %@", clients);
                                NSMutableDictionary* clientsDict = [[NSMutableDictionary alloc]init];
                                for (WS_Client* client in clients) {
                                    [clientsDict setObject:client forKey:client.clientId.stringValue];
                                }
                                sharedModel.clientsDictionary = clientsDict;
                                sharedModel.clients = [[NSMutableArray alloc]initWithArray:clients];
 
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}
   
@end

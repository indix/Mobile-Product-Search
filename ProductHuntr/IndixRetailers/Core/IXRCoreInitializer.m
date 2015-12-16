//
//  IXRCoreInitializer.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 08/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCoreInitializer.h"
#import "IXApiCore.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "IXRUtils.h"

@interface IXRCoreInitializer ()



@end


@implementation IXRCoreInitializer

#pragma mark - Indix API Initialization methods
+ (void)initializeIndixApiFromPropertyListFileAtLocation:(NSString *)string {
    NSDictionary *dictionary = [IXRUtils readPropertiesFrompList:string];
    [IXApiCore setServiceTokenId:[dictionary objectForKey:@"indix_app_id"]
                          appKey:[dictionary objectForKey:@"indix_app_key"]];
}


@end

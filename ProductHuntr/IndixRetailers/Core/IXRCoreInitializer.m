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


#define RETAILER_APP_VERSION 2
#define RETAILER_APP_VERSION_NAME @"BlueBerry"

#define USER_DEFAULT_WHAT_NEW_SEEN @"USER_DEFAULT_WHAT_NEW_SEEN"

@interface IXRCoreInitializer ()



@end

static NSDictionary* propertyListDIct = nil;

@implementation IXRCoreInitializer

#pragma mark - Indix API Initialization methods
+ (void)initializeIndixApi {
    [IXApiCore setServiceTokenId:[IXRCoreInitializer readPropertyOfKey:@"indix_app_id"]
                          appKey:[IXRCoreInitializer readPropertyOfKey:@"indix_app_key"]];
}


#pragma mark - Utilities methods

+ (void)initializeCoreFromPropertyListFileAtLocation:(NSString *)string {
    NSDictionary *dictionary = [IXRUtils readPropertiesFrompList:string];
    propertyListDIct = dictionary;
}

+ (NSString *)readPropertyOfKey:(NSString *)string {
    return [propertyListDIct objectForKey:string];
}

@end

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

#pragma mark - Parse Initialization methods


+ (void)requestSeenWhatNewControllerForCurrentVersion {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:RETAILER_APP_VERSION] forKey:USER_DEFAULT_WHAT_NEW_SEEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)shouldShowWhatNewControllerForCurrentVersion {
    NSNumber *key = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_WHAT_NEW_SEEN];
    if (key) {
        NSInteger version = [key integerValue];
        if (version >= RETAILER_APP_VERSION) {
            return false;
        }
    }
    return true;
    
}




+ (void)handleApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
}

+ (void)handleApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Parse Push Notification
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

+ (void)handleApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Parse Push Notificaiton
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

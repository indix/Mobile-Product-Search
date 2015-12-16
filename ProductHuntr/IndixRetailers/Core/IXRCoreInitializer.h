//
//  IXRCoreInitializer.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 08/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXRCoreInitializer : NSObject

// Call this first in application:viewDidLoad
+ (void)initializeCoreFromPropertyListFileAtLocation:(NSString *)string;


+ (void)handleApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)handleApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

+ (void)handleApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


+ (void)requestSeenWhatNewControllerForCurrentVersion;
+ (BOOL)shouldShowWhatNewControllerForCurrentVersion;


// Initialize Indix api core
+ (void)initializeIndixApi;

@end

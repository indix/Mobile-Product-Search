//
//  IXRCoreInitializer.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 08/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXRCoreInitializer : NSObject

/**
    Used in app delegate to initialize the indix api and helpers with 'indix api key and themes'
 */

// Call this first in application:viewDidLoad
+ (void)initializeCoreFromPropertyListFileAtLocation:(NSString *)string;

// Initialize Indix api core
+ (void)initializeIndixApi;

@end

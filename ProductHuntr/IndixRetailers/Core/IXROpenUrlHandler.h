//
//  IXROpenUrlHandler.h
//  ProductHuntr
//
//  Created by Nalin Chhajer on 05/01/16.
//  Copyright © 2016 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kIXROpenUrlTypeProductDetail;
extern NSString * const kIXROpenUrlTypeProductSearch;

@protocol IXROpenUrlHandlerDelagate;

@interface IXROpenUrlHandler : NSObject

@property (nonatomic, assign) id<IXROpenUrlHandlerDelagate> delegate;

- (instancetype)init;

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

@protocol IXROpenUrlHandlerDelagate <NSObject>

- (void)handleOpenUrlOfType:(NSString *)type parameters:(NSDictionary *)parameters;

@optional
- (void)handleOpenUrlCallOfCaltalogForProduct:(NSString *)mpid;
- (void)handleOpenUrlCallForSearch:(NSString *)query;
@end
//
//  IXRTheme.h
//  IndiXetail
//
//  Created by Nalin Chhajer on 23/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXRetailerHelperConfig : NSObject

/**
 Helper class to save some theme related attributes which UI can use.s
 */

@property (nonatomic, strong) NSDictionary *customThemeProperties;
@property (nonatomic, strong, readonly) UIColor *navigationBarBarTintColor;
@property (nonatomic, strong, readonly) UIColor *navigationBarTintColor;
@property (nonatomic, strong, readonly) UIColor *navigationBarTitleTextAttributeForegroundColor;
@property (nonatomic, strong, readonly) UIColor *buttonTintColor;

@property (nonatomic, strong, readonly) NSString *homeScreenBlurredBackgroundImage;
@property (nonatomic, strong, readonly) UIColor *homeScreenBlurredBackgroundTintColor;
@property (nonatomic, strong, readonly) NSString *listTitleBlurredBackgroundImage;
@property (nonatomic, strong, readonly) NSString *homeAppLogoImage;
@property (nonatomic, strong, readonly) NSString *widgetAppLogoImage;

@property (nonatomic, strong, readonly) NSString *shareWidgetIdentifier;
@property (nonatomic, strong, readonly) NSString *groupIdentifier;
@property (nonatomic, strong, readonly) NSString *databaseName;

+ (id)instance;

- (void)setConfigFrompList:(NSString *)pListPath;


@end

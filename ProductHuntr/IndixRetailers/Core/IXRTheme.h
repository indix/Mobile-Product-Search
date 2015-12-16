//
//  IXRTheme.h
//  IndiXetail
//
//  Created by Nalin Chhajer on 23/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXRTheme : NSObject

@property (nonatomic, strong) NSDictionary *customThemeProperties;
@property (nonatomic, strong, readonly) UIColor *navigationBarBarTintColor;
@property (nonatomic, strong, readonly) UIColor *navigationBarTintColor;
@property (nonatomic, strong, readonly) UIColor *navigationBarTitleTextAttributeForegroundColor;
@property (nonatomic, strong, readonly) UIColor *buttonTintColor;

@property (nonatomic, strong, readonly) NSString *homeScreenBlurredBackgroundImage;
@property (nonatomic, strong, readonly) UIColor *homeScreenBlurredBackgroundTintColor;
@property (nonatomic, strong, readonly) NSString *listTitleBlurredBackgroundImage;
@property (nonatomic, strong, readonly) NSString *homeAppLogoImage;

+ (id)instance;

- (void)setThemeFrompList:(NSString *)pListPath;



@end

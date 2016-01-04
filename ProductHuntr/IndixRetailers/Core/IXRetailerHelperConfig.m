//
//  IXRTheme.m
//  IndiXetail
//
//  Created by Nalin Chhajer on 23/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import "IXRetailerHelperConfig.h"
#import "IXRUtils.h"
#import "UIColor+Extended.h"
#import "IXApiV2Core.h"

@implementation IXRetailerHelperConfig

+ (id)instance {
    
    static IXRetailerHelperConfig* sharedAppearance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppearance = [[IXRetailerHelperConfig alloc] init];
        [sharedAppearance refreshAppearanceProperties]; //defaults get set.
        
    });
    
    return sharedAppearance;
}

#pragma mark - Indix API Initialization methods
- (BOOL)initializeIndixApiFromPropertyList {
    if ([_customThemeProperties objectForKey:@"indix_app_id"] && [_customThemeProperties objectForKey:@"indix_app_key"]) {
        [IXApiV2Core setServiceTokenId:[_customThemeProperties objectForKey:@"indix_app_id"]
                                appKey:[_customThemeProperties objectForKey:@"indix_app_key"]];
        return YES;
    }
    return NO;
}


- (void)setConfigFrompList:(NSString *)pListPath {
    [self setCustomThemeProperties:[IXRUtils readPropertiesFrompList:pListPath]];
}

- (void)setCustomThemeProperties:(NSDictionary *)customThemeProperties {
    _customThemeProperties = customThemeProperties;
    if (![self initializeIndixApiFromPropertyList]) {
        NSLog(@"Indix Api id and key was not defined");
    }
    [self refreshAppearanceProperties]; //if theme exist, those colors or fonts get set.
}

- (void)refreshAppearanceProperties {
    
}

- (UIColor *)navigationBarBarTintColor {
    UIColor *color = [self readColorPropertiesForKey:@"barTintColor"];
    if (color) {
        return color;
    }
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (UIColor *)navigationBarTintColor {
    UIColor *color = [self readColorPropertiesForKey:@"tintColor"];
    if (color) {
        return color;
    }
    return [UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0];
}

- (UIColor *)navigationBarTitleTextAttributeForegroundColor {
    UIColor *color = [self readColorPropertiesForKey:@"titleTextAttributeForegroundColor"];
    if (color) {
        return color;
    }
    return [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
}

- (UIColor *)buttonTintColor {
    UIColor *color = [self readColorPropertiesForKey:@"buttonTintColor"];
    if (color) {
        return color;
    }
    return [UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0];
}

- (UIColor *)homeScreenBlurredBackgroundTintColor {
    UIColor *color = [self readColorPropertiesForKey:@"homeScreenBlurredBackgroundTintColor"];
    if (color) {
        return color;
    }
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9];
}

- (NSString *)homeScreenBlurredBackgroundImage {
    NSString *str = [self readStringPropertiesForKey:@"homeScreenBlurredBackgroundImage"];
    if (str) {
        return str;
    }
    return @"searchbar_bg.png";
}

- (NSString *)listTitleBlurredBackgroundImage {
    NSString *str = [self readStringPropertiesForKey:@"listTitleBlurredBackgroundImage"];
    if (str) {
        return str;
    }
    return @"PetSupplies.png";
}


- (NSString *)homeAppLogoImage {
    NSString *str = [self readStringPropertiesForKey:@"homeAppLogoImage"];
    if (str) {
        return str;
    }
    return @"home_app_name.png";
}

- (NSString *)widgetAppLogoImage {
    NSString *str = [self readStringPropertiesForKey:@"widgetAppLogoImage"];
    if (str) {
        return str;
    }
    return @"home_app_name.png";
}

- (NSString *)shareWidgetIdentifier {
    NSString *str = [self readStringPropertiesForKey:@"share_widget_identifier"];
    if (str) {
        return str;
    }
    return @"producthuntr";
}

- (NSString *)groupIdentifier {
    NSString *str = [self readStringPropertiesForKey:@"group_identifier"];
    if (str) {
        return str;
    }
    return @"group.com.indix.opensource.ProductHuntr";
}

- (NSString *)databaseName {
    NSString *str = [self readStringPropertiesForKey:@"database_name"];
    if (str) {
        return str;
    }
    return @"producthuntr.sqlite";
}

- (NSString *)readStringPropertiesForKey:(NSString *)key {
    if ([_customThemeProperties objectForKey:key]) {
        NSString *color = [_customThemeProperties objectForKey:key];
        return color;
    }
    return nil;
}

- (UIColor *)readColorPropertiesForKey:(NSString *)key {
     if ([_customThemeProperties objectForKey:key]) {
         UIColor *color = [UIColor colorFromRGBAString:[_customThemeProperties objectForKey:key]];
         return color;
     }
    return nil;
}

@end

//
//  IXRUtils.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 19/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline BOOL IXDeviceOrientationPortrait(UIDeviceOrientation orientation) {
    return ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown || (orientation) == UIDeviceOrientationFaceUp || (orientation) == UIDeviceOrientationFaceDown);
}


@interface IXRUtils : NSObject

+ (NSDictionary *)readPropertiesFrompList:(NSString *)pListPath;
+ (NSData *)contentOfFile:(NSString *)name type:(NSString *)type;
+ (NSString *)shortStringForInteger:(NSInteger)value;
+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+ (Boolean) isValidEmail: (NSString*) email;
+ (UIColor *)generateColorAtIndex:(NSInteger)index;
+ (CGSize)findHeightForAttributedText:(NSAttributedString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+ (NSString *)getCategoryImage:(NSString *)categoryId;


@end

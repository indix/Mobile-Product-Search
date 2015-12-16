//
//  IXRPriceTypeUtils.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 16/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXRPriceTypeUtils : NSObject

+ (NSString *)generatePriceStringForPrice:(NSString *)price type:(NSString *)type;
+ (BOOL)isSupportedPriceType:(NSString *)string;
+ (NSString *)defaultPriceType;
+ (BOOL)isALLNumber:(NSString *)string;

+ (NSString *)generatePriceRangeFromMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice currency:(NSString *)currency;

@end

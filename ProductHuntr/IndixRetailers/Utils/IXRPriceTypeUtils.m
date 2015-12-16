//
//  IXRPriceTypeUtils.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 16/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRPriceTypeUtils.h"

#define HAS_DECIMALS(x) (x != (int)x)

@implementation IXRPriceTypeUtils

+ (BOOL)isSupportedPriceType:(NSString *)string {
    if ([[string lowercaseString] isEqualToString:@"usd"]) {
        return YES;
    }
    if ([[string lowercaseString] isEqualToString:@"inr"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)defaultPriceType {
    return @"USD";
}

+ (NSString *)generatePriceStringForPrice:(NSString *)price type:(NSString *)type {
    if (!type) {
        type = [self defaultPriceType];
    }
    
    if([self isSupportedPriceType:type]) {
        return [self patchPrice:price type:type];
    }
    return price;
}

+ (NSString *)patchPrice:(NSString *)price type:(NSString *)type {
    if ([[type lowercaseString] isEqualToString:@"usd"]) {
        if ([self isALLNumber:price]) {
            return [self patchPriceDecimal:price currency:@"$"];
        }
        else {
            return price;
        }
        
    }
    
    if ([[type lowercaseString] isEqualToString:@"inr"]) {
        if ([self isALLNumber:price]) {
            return [self patchPriceDecimal:price currency:@"₹"];
        }
        else {
            return price;
        }
        
    }
    return price;
}

+ (NSString *)patchPriceDecimal:(NSString *)price currency:(NSString *)currency{
    if (HAS_DECIMALS([price doubleValue])) {
        return [NSString stringWithFormat:@"%@%0.2f", currency, [price doubleValue]];
    }
    else {
        return [NSString stringWithFormat:@"%@%0.0f", currency, [price doubleValue]];
    }
}

+ (BOOL)isALLNumber:(NSString *)string {
    double price_f = [string doubleValue];
    if (price_f != 0.0) {
        return YES;
    }
    return NO;
}

+ (NSString *)generatePriceRangeFromMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice currency:(NSString *)currency {
    NSString *minPriceLabel = [self generatePriceStringForPrice:minPrice type:currency];
    NSString *maxPriceLabel = [self generatePriceStringForPrice:maxPrice type:currency];
    if ([minPriceLabel isEqualToString:maxPriceLabel]) {
        return [NSString stringWithFormat:@"%@", minPriceLabel];
    }
    else {
        return [NSString stringWithFormat:@"%@ - %@", minPriceLabel, maxPriceLabel];
    }
}



@end

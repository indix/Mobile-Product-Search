//
//  IXMSearchType.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 18/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMSearchType.h"

NSString *const kIXRSearchTypeAll = @"all";
NSString *const kIXRSearchTypeMPN = @"mpn";
NSString *const kIXRSearchTypeUPC = @"upc";
NSString *const kIXRSearchTypeSKU = @"sku";

@implementation IXMSearchType

- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key {
    if (self = [super init]) {
        self.title = title;
        self.key = key;
    }
    return self;
}

+ (IXMSearchType *)getSearchtypeForKey:(NSString *)key {
    
    if ([key isEqualToString:kIXRSearchTypeAll]) {
        return [[IXMSearchType alloc] initWithTitle:@"ALL" andKey:kIXRSearchTypeAll];
    }
    if ([key isEqualToString:kIXRSearchTypeSKU]) {
        return [[IXMSearchType alloc] initWithTitle:@"SKU" andKey:kIXRSearchTypeSKU];
    }
    if ([key isEqualToString:kIXRSearchTypeMPN]) {
        return [[IXMSearchType alloc] initWithTitle:@"MPN" andKey:kIXRSearchTypeMPN];
    }
    if ([key isEqualToString:kIXRSearchTypeUPC]) {
        return [[IXMSearchType alloc] initWithTitle:@"UPC" andKey:kIXRSearchTypeUPC];
    }
    
    
    return nil;
}

+ (NSArray *)getAllSearchTypes {
    return @[[self getSearchtypeForKey:kIXRSearchTypeAll],
//             [self getSearchtypeForKey:kIXRSearchTypeSKU],
//             [self getSearchtypeForKey:kIXRSearchTypeMPN],
             [self getSearchtypeForKey:kIXRSearchTypeUPC]];
}

@end

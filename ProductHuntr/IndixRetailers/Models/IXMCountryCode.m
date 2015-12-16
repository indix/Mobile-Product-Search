//
//  IXMCountryCode.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 25/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMCountryCode.h"

NSString *const kIXRCountryCodeUS = @"US";
NSString *const kIXRCountryCodeIN = @"IN";

@implementation IXMCountryCode

- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key {
    if (self = [super init]) {
        self.title = title;
        self.key = key;
    }
    return self;
}

+ (IXMCountryCode *)getCountryCodeForKey:(NSString *)key {
    if ([key isEqualToString:kIXRCountryCodeUS]) {
        return [[IXMCountryCode alloc] initWithTitle:@"United States" andKey:kIXRCountryCodeUS];
    }
    if ([key isEqualToString:kIXRCountryCodeIN]) {
        return [[IXMCountryCode alloc] initWithTitle:@"India" andKey:kIXRCountryCodeIN];
    }
    return nil;
}

+ (NSArray *)getAllCountryCode {
    return @[[self getCountryCodeForKey:kIXRCountryCodeUS], [self getCountryCodeForKey:kIXRCountryCodeIN]];
}

+ (IXMCountryCode *)getDefaultCountyCode {
    return [self getCountryCodeForKey:kIXRCountryCodeUS];
}

@end

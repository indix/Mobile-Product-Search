//
//  IXMSortType.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 22/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMSortType.h"


NSString *const kIXRSortTypeRelevance = @"relevance";
NSString *const kIXRSortTypeMostRecent = @"most_recent";
NSString *const kIXRSortTypePriceHighToLow = @"price_high_low";
NSString *const kIXRSortTypePriceLowToHigh = @"price_low_high";

@implementation IXMSortType

- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key {
    if (self = [super init]) {
        self.title = title;
        self.key = key;
    }
    return self;
}

+ (IXMSortType *)getSorttypeForKey:(NSString *)key {
    if ([key isEqualToString:kIXRSortTypeRelevance]) {
        return [[IXMSortType alloc] initWithTitle:@"Relevance" andKey:kIXRSortTypeRelevance];
    }
    if ([key isEqualToString:kIXRSortTypePriceHighToLow]) {
        return [[IXMSortType alloc] initWithTitle:@"Price (High to Low)" andKey:kIXRSortTypePriceHighToLow];
    }
    if ([key isEqualToString:kIXRSortTypePriceLowToHigh]) {
        return [[IXMSortType alloc] initWithTitle:@"Price (Low to High)" andKey:kIXRSortTypePriceLowToHigh];
    }
    if ([key isEqualToString:kIXRSortTypeMostRecent]) {
        return [[IXMSortType alloc] initWithTitle:@"Most Recent" andKey:kIXRSortTypeMostRecent];
    }
    return nil;
}

+ (NSArray *)getAllSortType {
    return @[[self getSorttypeForKey:kIXRSortTypeRelevance], [self getSorttypeForKey:kIXRSortTypeMostRecent], [self getSorttypeForKey:kIXRSortTypePriceHighToLow], [self getSorttypeForKey:kIXRSortTypePriceLowToHigh]];
}


@end

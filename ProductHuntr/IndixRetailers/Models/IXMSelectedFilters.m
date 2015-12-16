//
//  IXMSelectedFilters.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 30/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMSelectedFilters.h"


NSString *const kIXRAvailabilityAll = @"all";
NSString *const kIXRAvailabilityInStock = @"in_stock";
NSString *const kIXRAvailabilityOutOfStock = @"out_stock";


@interface IXMSelectedFilters ()

@end

@implementation IXMSelectedFilters

- (instancetype)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (BOOL)containsFilter {
    return [self.selectedCategory count] > 0 ||
    [self.selectedBrand count] > 0 ||
    [self.selectedStores count] > 0 || [self isAvailabilityFilterSelected] || self.minPrice > 0 || self.maxPrice > 0;
}

- (void)reset {
    self.selectedBrand = [[NSMutableArray alloc] init];
    self.selectedCategory = [[NSMutableArray alloc] init];
    self.selectedStores = [[NSMutableArray alloc] init];
    self.availabilityFilterType = kIXRAvailabilityAll;
    self.minPrice = -1;
    self.maxPrice = -1;
}

- (void)clearFilters {
    [self reset];
}

#pragma mark - stores
- (BOOL)isStoreSelected:(IXMStoreFilter *)filter {
    IXMStoreFilter *sf = [self getStoreFromKey:filter];
    return sf != nil;
}

- (void)addStore:(IXMStoreFilter *)filter {
    IXMStoreFilter *sf = [self getStoreFromKey:filter];
    if (!sf) {
        [self.selectedStores addObject:filter];
    }
}

- (void)removeStore:(IXMStoreFilter *)filter {
    IXMStoreFilter *sf = [self getStoreFromKey:filter];
    if (sf) {
        [self.selectedStores removeObject:sf];
    }
}

- (IXMStoreFilter *)getStoreFromKey:(IXMStoreFilter *)filter {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"key", filter.key];
    NSArray *array = [self.selectedStores filteredArrayUsingPredicate:p];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

#pragma mark - categories
- (BOOL)isCategorySelected:(IXMCategoryFilter *)filter {
    IXMCategoryFilter *sf = [self getCategoryFromKey:filter];
    return sf != nil;
}

- (void)addCategory:(IXMCategoryFilter *)filter {
    IXMCategoryFilter *sf = [self getCategoryFromKey:filter];
    if (!sf) {
        [self.selectedCategory removeAllObjects]; // Done to handle only one category selection
        [self.selectedCategory addObject:filter];
    }
}

- (void)removeCategory:(IXMCategoryFilter *)filter {
    IXMCategoryFilter *sf = [self getCategoryFromKey:filter];
    if (sf) {
        [self.selectedCategory removeObject:sf];
    }
}

- (IXMCategoryFilter *)getCategoryFromKey:(IXMCategoryFilter *)filter {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"key", filter.key];
    NSArray *array = [self.selectedCategory filteredArrayUsingPredicate:p];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

#pragma mark - brand
- (BOOL)isBrandSelected:(IXMBrandFilter *)filter {
    IXMBrandFilter *sf = [self getBrandFromKey:filter];
    return sf != nil;
}

- (void)addBrand:(IXMBrandFilter *)filter {
    IXMBrandFilter *sf = [self getBrandFromKey:filter];
    if (!sf) {
        [self.selectedBrand addObject:filter];
    }
}

- (void)removeBrand:(IXMBrandFilter *)filter {
    IXMBrandFilter *sf = [self getBrandFromKey:filter];
    if (sf) {
        [self.selectedBrand removeObject:sf];
    }
}

- (IXMBrandFilter *)getBrandFromKey:(IXMBrandFilter *)filter {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"key", filter.key];
    NSArray *array = [self.selectedBrand filteredArrayUsingPredicate:p];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

- (NSInteger)selectedCount {
    return self.selectedBrand.count + self.selectedCategory.count + self.selectedStores.count;
}

- (BOOL)isAvailabilityFilterSelected {
    if (self.availabilityFilterType) {
        if ([self.availabilityFilterType isEqualToString:kIXRAvailabilityInStock] || [self.availabilityFilterType isEqualToString:kIXRAvailabilityOutOfStock]) {
            return YES;
        }
    }
    return NO;
}


- (NSString *)printAllFilter {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"Brand: "];
    [string appendString:[self printBrandFilter]];
    [string appendString:@"\nStore: "];
    [string appendString:[self printStoreFilter]];
    [string appendString:@"\nCategory: "];
    [string appendString:[self printCategoryFilter]];
    return string;
}

- (NSString *)printBrandFilter {
    if (self.selectedBrand.count > 0) {
        NSMutableString *string = [[NSMutableString alloc] init];
        for (IXMBrandFilter *object in self.selectedBrand) {
            [string appendString:object.name];
            [string appendString:@", "];
        }
        return string;
    }
    return @"";
}

- (NSString *)printCategoryFilter {
    if (self.selectedCategory.count > 0) {
        NSMutableString *string = [[NSMutableString alloc] init];
        for (IXMCategoryFilter *object in self.selectedCategory) {
            [string appendString:object.name];
            [string appendString:@", "];
        }
        return string;
    }
    return @"";
}

- (NSString *)printStoreFilter {
    if (self.selectedStores.count > 0) {
        NSMutableString *string = [[NSMutableString alloc] init];
        for (IXMStoreFilter *object in self.selectedStores) {
            [string appendString:object.name];
            [string appendString:@", "];
        }
        return string;
    }
    return @"";
}

@end

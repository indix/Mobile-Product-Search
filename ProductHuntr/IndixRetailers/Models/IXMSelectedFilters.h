//
//  IXMSelectedFilters.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 30/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMStoreFilter.h"
#import "IXMBrandFilter.h"
#import "IXMCategoryFilter.h"


extern NSString * const kIXRAvailabilityAll;
extern NSString * const kIXRAvailabilityInStock;
extern NSString * const kIXRAvailabilityOutOfStock;



@interface IXMSelectedFilters : NSObject

/**
 Model for filters
 */

@property (nonatomic, strong) NSMutableArray *selectedStores;
@property (nonatomic, strong) NSMutableArray *selectedCategory;
@property (nonatomic, strong) NSMutableArray *selectedBrand;
@property (nonatomic, strong) NSString *availabilityFilterType; // Any of kIXRAvailabilityAll, kIXRAvailabilityInStock, kIXRAvailabilityOutOfStock. Default is kIXRAvailabilityAll.
@property (nonatomic, assign) double minPrice;
@property (nonatomic, assign) double maxPrice;

- (BOOL)containsFilter;
- (void)clearFilters;

- (BOOL)isStoreSelected:(IXMStoreFilter *)filter;
- (void)addStore:(IXMStoreFilter *)filter;
- (void)removeStore:(IXMStoreFilter *)filter;

- (BOOL)isCategorySelected:(IXMCategoryFilter *)filter;
- (void)addCategory:(IXMCategoryFilter *)filter;
- (void)removeCategory:(IXMCategoryFilter *)filter;

- (BOOL)isBrandSelected:(IXMBrandFilter *)filter;
- (void)addBrand:(IXMBrandFilter *)filter;
- (void)removeBrand:(IXMBrandFilter *)filter;

- (NSInteger)selectedCount;

- (NSString *)printAllFilter;
- (NSString *)printBrandFilter;
- (NSString *)printCategoryFilter;
- (NSString *)printStoreFilter;

@end

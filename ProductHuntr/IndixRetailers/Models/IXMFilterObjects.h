//
//  IXMFilterObjects.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMStoreFilter.h"
#import "IXMCategoryFilter.h"
#import "IXMBrandFilter.h"


@interface IXMFilterObjects : NSObject

/**
 Model for filter
 */

@property (nonatomic, strong) NSArray *storeFilters;
@property (nonatomic, strong) NSArray *categoryFilters;
@property (nonatomic, strong) NSArray *brandFilters;

- (instancetype)initWithV2ProductModel:(NSDictionary *)dict categoryTreeIndex:(NSInteger)treeIndex ;

- (BOOL)containsFilter;

@end

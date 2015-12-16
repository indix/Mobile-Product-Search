//
//  IXMFilterObjects.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMFilterObjects.h"

@implementation IXMFilterObjects

- (instancetype)initWithV2ProductModel:(NSDictionary *)dict categoryTreeIndex:(NSInteger)treeIndex {
    if (self = [super init]) {
        {
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            NSArray *array = [dict objectForKey:@"categoryId"];
            if (array) {
                for (NSDictionary *object in array) {
                    [outputArray addObject:[[IXMCategoryFilter alloc] initWithV2ProductModel:object treeIndex:treeIndex]];
                }
            }
            self.categoryFilters = outputArray;
        }
        
        {
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            NSArray *array = [dict objectForKey:@"brandId"];
            if (array) {
                for (NSDictionary *object in array) {
                    [outputArray addObject:[[IXMBrandFilter alloc] initWithV2ProductModel:object]];
                }
            }
            self.brandFilters = outputArray;
        }
        
        {
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            NSArray *array = [dict objectForKey:@"storeId"];
            if (array) {
                for (NSDictionary *object in array) {
                    [outputArray addObject:[[IXMStoreFilter alloc] initWithV2ProductModel:object]];
                }
            }
            self.storeFilters = outputArray;
        }
    }
    return self;
}

- (BOOL)containsFilter {
    return [self.categoryFilters count] > 0 ||
            [self.brandFilters count] > 0 ||
            [self.storeFilters count] > 0;
}

@end

//
//  IXMDisplayCategoryFilter.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 05/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMDisplayCategoryFilter.h"

@implementation IXMDisplayCategoryFilter

- (instancetype)initWithInitialCategory:(NSArray *)category {
    if (self = [super init]) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:category];
        self.categoryDislayArray = array;
    }
    return self;
}

- (BOOL)addSubCategoryForCategory:(IXMCategoryFilter *)category subCategory:(NSArray *)subCategory {
    IXMCategoryFilter *savedCategory = [self getCategoryFromKey:category];
    NSInteger index = [self positionOfCategory:savedCategory];
    if (index < 0) {
        return NO;
    }
    else {
        savedCategory.isSubCategoryDownloaded = YES;
        savedCategory.subCategoryCount = subCategory.count;
        for(int i = 0; i < subCategory.count; i++) {
            IXMCategoryFilter *subCat = [subCategory objectAtIndex:i];
            if ([savedCategory.key isEqualToString:subCat.key]) {
                savedCategory.isLastLeaf = YES;
            }
            else {
                [self.categoryDislayArray insertObject:[subCategory objectAtIndex:i] atIndex:index+i+1];
            }
            
        }
        return YES;
    }
}

- (NSInteger)indexPositionOfCategory:(IXMCategoryFilter *)category {
    IXMCategoryFilter *savedCategory = [self getCategoryFromKey:category];
    NSInteger index = [self positionOfCategory:savedCategory];
    return index;
}

- (NSInteger)positionOfCategory:(IXMCategoryFilter *)savedCategory {
    return [self.categoryDislayArray indexOfObject:savedCategory];
}

- (IXMCategoryFilter *)getCategoryFromKey:(IXMCategoryFilter *)filter {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"key", filter.key];
    NSArray *array = [self.categoryDislayArray filteredArrayUsingPredicate:p];
    if (array.count > 0) {
        return [array firstObject];
    }
    return nil;
}

- (IXMCategoryFilter *)objectAtIndex:(NSUInteger)index {
    return [self.categoryDislayArray objectAtIndex:index];
}

- (NSInteger)count {
    return self.categoryDislayArray.count;
}

- (BOOL)removeAllSubCategoryOfCategory:(IXMCategoryFilter *)category {
    IXMCategoryFilter *savedCategory = [self getCategoryFromKey:category];
    NSInteger index = [self positionOfCategory:savedCategory];
    if (index < 0) {
        return NO;
    }
    else {
        NSInteger treeIndex = [savedCategory treeIndex];
        
        NSInteger indexCount = index + 1;
        while (indexCount < self.categoryDislayArray.count) {
            IXMCategoryFilter *subCat = [self.categoryDislayArray objectAtIndex:indexCount];
            if (subCat.treeIndex <= treeIndex) {
                break;
            }
            else {
                if (self.delegate) {
                    [self.delegate willDeleteSubCategory:subCat];
                }
                [self.categoryDislayArray removeObjectAtIndex:indexCount];
                // Send delegate back
                
            }
            indexCount = index + 1;
        }
        
        savedCategory.isSubCategoryDownloaded = NO;
        return YES;
    }
}

@end

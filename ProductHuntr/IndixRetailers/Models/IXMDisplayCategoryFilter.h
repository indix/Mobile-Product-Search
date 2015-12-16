//
//  IXMDisplayCategoryFilter.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 05/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMCategoryFilter.h"

@protocol IXMDisplayCategoryFilterDelagete;

@interface IXMDisplayCategoryFilter : NSObject

@property (nonatomic, strong) NSMutableArray *categoryDislayArray;

@property (nonatomic, assign) id<IXMDisplayCategoryFilterDelagete> delegate;

- (instancetype)initWithInitialCategory:(NSArray *)category;


- (BOOL)addSubCategoryForCategory:(IXMCategoryFilter *)category subCategory:(NSArray *)subCategory;

- (IXMCategoryFilter *)objectAtIndex:(NSUInteger)index;
- (NSInteger)count;

- (BOOL)removeAllSubCategoryOfCategory:(IXMCategoryFilter *)category;

- (NSInteger)indexPositionOfCategory:(IXMCategoryFilter *)category;

@end

@protocol IXMDisplayCategoryFilterDelagete <NSObject>

- (void)willDeleteSubCategory:(IXMCategoryFilter *)filter;

@end
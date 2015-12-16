//
//  IXMCategoryFilter.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMCategoryFilter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *key; // id
@property (nonatomic, assign) NSInteger treeIndex;
@property (nonatomic, strong, readonly) NSString *displayName;

@property (nonatomic, assign) BOOL isSubCategoryDownloaded;
@property (nonatomic, assign) NSInteger subCategoryCount;
@property (nonatomic, assign) BOOL isLastLeaf;

- (instancetype)initWithV2ProductModel:(NSDictionary *)dict treeIndex:(NSInteger)treeIndex;

@end

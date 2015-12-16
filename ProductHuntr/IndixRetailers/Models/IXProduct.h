//
//  IXProduct.h
//  Indix Dynamo
//
//  Created by Senthil Kumar
//  Copyright (c) 2013 Indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXProduct : NSObject

/**
 Model to store product attributes
 */

@property (nonatomic, strong) NSString *mpid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *priceRange;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *noOfStores;

@property (nonatomic, strong) NSString *minSalePrice;
@property (nonatomic, strong) NSString *maxSalePrice;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong, readonly) NSString *priceRangeLabel;
@property (nonatomic, strong) NSString *indixVersionType;

@property (nonatomic, strong) NSString *categoryIdPath;
@property (nonatomic, strong) NSString *categoryNamePath;


+ (IXProduct *) productWithIdentifier:(NSString *)identifier name:(NSString *)name;
+ (NSString *)patchProductPriceRange:(NSString *)givenRange;

- (instancetype)initWithProductModel:(NSDictionary *)productDictionary;
- (instancetype)initWithV2ProductModel:(NSDictionary *)productDictionary;

- (NSArray *)allCategoryName;
- (NSArray *)allCategoryId;

@end



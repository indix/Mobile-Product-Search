//
//  IXMSavedProduct.h
//  ProductHuntr
//
//  Created by Nalin Chhajer on 29/12/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXProduct.h"

@interface IXMSavedProduct : NSObject

@property (nonatomic, strong) NSString *mpid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *priceRange;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *noOfStores;
@property (nonatomic, strong) NSArray *productStores;
@property (nonatomic, strong) NSNumber *lastRefreshTime;

@property (nonatomic, strong) NSString *minSalePrice;
@property (nonatomic, strong) NSString *maxSalePrice;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong, readonly) NSString *priceRangeLabel;
@property (nonatomic, strong, readonly) NSDate *lastRefreshTimeDate;
@property (nonatomic, strong) NSString *indixVersionType;

@property (nonatomic, strong) NSString *categoryIdPath;
@property (nonatomic, strong) NSString *categoryNamePath;

- (void)copyFromProduct:(IXProduct *)product;
- (IXProduct *)copyOFProduct;

@end

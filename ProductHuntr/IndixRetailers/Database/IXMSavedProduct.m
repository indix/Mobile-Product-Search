//
//  IXMSavedProduct.m
//  ProductHuntr
//
//  Created by Nalin Chhajer on 29/12/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import "IXMSavedProduct.h"
#import "IXRPriceTypeUtils.h"

@implementation IXMSavedProduct

@dynamic pid;
@dynamic mpid;
@dynamic name;
@dynamic priceRange;
@dynamic imageURL;
@dynamic noOfStores;
@dynamic minSalePrice;
@dynamic maxSalePrice;
@dynamic currency;
@dynamic indixVersionType;
@dynamic lastRefreshTime;
@dynamic categoryIdPath;
@dynamic categoryNamePath;


- (void)copyFromProduct:(IXProduct *)product {
    self.pid = product.pid;
    self.mpid = product.mpid;
    self.name = product.name;
    self.priceRange = product.priceRange;
    self.imageURL = product.imageURL;
    self.noOfStores = product.noOfStores;
    self.minSalePrice = product.minSalePrice;
    self.maxSalePrice = product.maxSalePrice;
    self.currency = product.currency;
    self.indixVersionType = product.indixVersionType;
    self.categoryNamePath = product.categoryNamePath;
    self.categoryIdPath = product.categoryIdPath;
    
}

- (IXProduct *)copyOFProduct {
    IXProduct *product = [[IXProduct alloc] init];
    product.pid = self.pid;
    product.mpid = self.mpid;
    product.name = self.name;
    product.priceRange = self.priceRange;
    product.imageURL = self.imageURL;
    product.noOfStores = self.noOfStores;
    product.minSalePrice = self.minSalePrice;
    product.maxSalePrice = self.maxSalePrice;
    product.currency = self.currency;
    product.indixVersionType = self.indixVersionType;
    product.categoryIdPath = self.categoryIdPath;
    product.categoryNamePath = self.categoryNamePath;
    return product;
}

- (NSString *)priceRangeLabel {
    if (self.minSalePrice && self.maxSalePrice) {
        return [IXRPriceTypeUtils generatePriceRangeFromMinPrice:self.minSalePrice maxPrice:self.maxSalePrice currency:self.currency];
    }
    else {
        return [IXProduct patchProductPriceRange:self.priceRange];
    }
}

- (NSDate *)lastRefreshTimeDate {
    if (self.lastRefreshTime) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:([self.lastRefreshTime doubleValue]/1000)];
        return date;
    }
    return nil;
}

@end

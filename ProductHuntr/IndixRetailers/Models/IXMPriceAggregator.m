//
//  IXMPriceAggregator.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 07/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMPriceAggregator.h"
#import "IXRPriceTypeUtils.h"

@implementation IXMPriceAggregator


- (instancetype)initWithPricePoint:(IXMProductPrice *)pricePoint {
    if (self = [super init]) {
        self.priceArray = [[NSMutableArray alloc] init];
        [self addPriceObject:pricePoint];
    }
    return self;
}

- (void)addPriceObject:(IXMProductPrice *)pricePoint {
    [self.priceArray addObject:pricePoint];
}

- (NSString *)imageUrl {
    IXMProductPrice *price = [self.priceArray firstObject];
    return price.imageUrl;
}

- (NSString *)storeName {
    IXMProductPrice *price = [self.priceArray firstObject];
    return price.storeName;
}

- (NSString *)productUrl {
    IXMProductPrice *price = [self.priceArray firstObject];
    return price.productUrl;
}

- (NSString *)availabilityStatus {
    IXMProductPrice *price = [self.priceArray firstObject];
    return price.availabilityStatus;
}

- (IXMProductPrice *)product {
    IXMProductPrice *price = [self.priceArray firstObject];
    return price;
}

- (NSString *)priceRange {
    double minPrice = HUGE_VAL;
    double maxPrice = minPrice;
    NSString *minPriceLabel = nil;
    NSString *maxPriceLabel = nil;
    
    for (IXMProductPrice *object in self.priceArray) {
        NSString *salePrice = object.salePrice;
        double price = [salePrice doubleValue];
        if (price == 0.0 || price == HUGE_VAL || price == -HUGE_VAL) {
            
        }
        else {
            if (minPrice == HUGE_VAL) {
                minPrice = price;
                maxPrice = minPrice;
                minPriceLabel = object.salePriceLabel;
                maxPriceLabel = object.salePriceLabel;
            }
            else {
                if (price < minPrice) {
                    minPrice = price;
                    minPriceLabel = object.salePriceLabel;
                }
                else if (price > maxPrice) {
                    maxPrice = price;
                    maxPriceLabel = object.salePriceLabel;
                }
                else {
                    
                }
            }
        }
    }
    if (minPrice == HUGE_VAL) {
        IXMProductPrice *price = [self.priceArray firstObject];
        return price.salePriceLabel;
    }
    else {
        if (minPrice == maxPrice) {
            IXMProductPrice *price = [self.priceArray firstObject];
            return price.salePriceLabel;
        }
        else {
            return [NSString stringWithFormat:@"%@ - %@", minPriceLabel, maxPriceLabel];
        }
    }
}

@end

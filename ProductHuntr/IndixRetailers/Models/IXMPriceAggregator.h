//
//  IXMPriceAggregator.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 07/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMProductPrice.h"

@interface IXMPriceAggregator : NSObject


@property (nonatomic, strong, readonly) NSString *imageUrl;
@property (nonatomic, strong, readonly) NSString *priceRange;
@property (nonatomic, strong, readonly) NSString *storeName;
@property (nonatomic, strong, readonly) NSString *availabilityStatus;
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSString *productUrl;
@property (nonatomic, strong) IXMProductPrice *product;

- (void)addPriceObject:(IXMProductPrice *)pricePoint;
- (instancetype)initWithPricePoint:(IXMProductPrice *)pricePoint;


@end

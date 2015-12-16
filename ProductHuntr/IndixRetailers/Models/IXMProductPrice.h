//
//  IXMProductPrice.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMProductPrice : NSObject

/**
 Model to store product price attributes
 */

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, strong) NSString *listPrice;
@property (nonatomic, strong) NSString *salePrice;
@property (nonatomic, strong) NSString *availabilityStatus;
@property (nonatomic, strong) NSString *productUrl;
@property (nonatomic, strong) NSDate *lastRecordedAt;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong, readonly) NSString *listPriceLabel;
@property (nonatomic, strong, readonly) NSString *salePriceLabel;

- (instancetype)initWithModel:(NSDictionary *)productDictionary;
- (instancetype)initWithV2Model:(NSDictionary *)productDictionary storeDict:(NSDictionary *)storeDict currency:(NSString *)currency;

@end

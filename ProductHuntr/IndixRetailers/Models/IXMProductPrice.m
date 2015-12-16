//
//  IXMProductPrice.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMProductPrice.h"
#import "IXRPriceTypeUtils.h"

@implementation IXMProductPrice

// As per indix api
- (instancetype)initWithModel:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        self.storeName = [productDictionary objectForKey:@"storeName"];
        if ([productDictionary objectForKey:@"price"]) {
            NSDictionary *priceDict = [productDictionary objectForKey:@"price"];
            self.listPrice = [priceDict objectForKey:@"listPrice"];
            self.salePrice = [priceDict objectForKey:@"salePrice"];
        }
        self.sellerName = [productDictionary objectForKey:@"sellerName"];
        self.availabilityStatus = [productDictionary objectForKey:@"availability"];
        self.productUrl = [productDictionary objectForKey:@"productUrl"];
        self.priceType = [IXRPriceTypeUtils defaultPriceType];
        self.pId = [productDictionary objectForKey:@"id"];
        
        NSInteger timeStamp = [[productDictionary objectForKey:@"lastRecordedAt"] integerValue];
        self.lastRecordedAt = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        
    }
    return self;
}

- (instancetype)initWithV2Model:(NSDictionary *)offerDictionary storeDict:(NSDictionary *)storeDict currency:(NSString *)currency {
    if (self = [super init]) {
        self.storeName = [storeDict objectForKey:@"storeName"];
        self.listPrice = [[offerDictionary objectForKey:@"listPrice"] stringValue];
        self.salePrice = [[offerDictionary objectForKey:@"salePrice"] stringValue];
        self.sellerName = [offerDictionary objectForKey:@"seller"];
        self.availabilityStatus = [offerDictionary objectForKey:@"availability"];
        self.productUrl = [offerDictionary objectForKey:@"productUrl"];
        self.priceType = currency;
        self.pId = [offerDictionary objectForKey:@"pid"];
        self.imageUrl = [offerDictionary objectForKey:@"imageUrl"];
        
        
        NSInteger timeStamp = [[offerDictionary objectForKey:@"lastRecordedAt"] integerValue];
        self.lastRecordedAt = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        
    }
    return self;
}

- (NSString *)listPriceLabel {
    return [IXRPriceTypeUtils generatePriceStringForPrice:self.listPrice type:self.priceType];
}

- (NSString *)salePriceLabel {
    return [IXRPriceTypeUtils generatePriceStringForPrice:self.salePrice type:self.priceType];
}

@end

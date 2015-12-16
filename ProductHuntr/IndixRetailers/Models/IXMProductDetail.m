//
//  IXMProductDetail.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMProductDetail.h"

@implementation IXMProductDetail

// As per indix api
- (instancetype)initWithModel:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        self.name = [productDictionary objectForKey:@"title"];
        self.imageURL = [productDictionary objectForKey:@"imageUrl"];
        self.brandName = [productDictionary objectForKey:@"brandName"];
        self.categoryName = [productDictionary objectForKey:@"categoryNamePath"];
        self.upcNumber = [self parseInformationFromDictionary:productDictionary forKey:@"upc"];
        
        NSMutableArray *sellerName = [[NSMutableArray alloc] init];
        
        NSArray *offersArray = [productDictionary objectForKey:@"offers"];
        for (NSDictionary *object in offersArray) {
            if (!self.skuNumber) self.skuNumber = [self parseInformationFromDictionary:object forKey:@"sku"];
            if (!self.mpnNumber) self.mpnNumber = [self parseInformationFromDictionary:object forKey:@"mpn"];
            NSString *seller = [self parseInformationFromDictionary:object forKey:@"sellerName"];
            if (seller && ![sellerName containsObject:seller]) {
                [sellerName addObject:seller];
            }
        }
        self.sellerNames = sellerName;
        
        NSMutableArray *attributeArray = [[NSMutableArray alloc] init];;
        NSDictionary *attributeDict = [productDictionary objectForKey:@"attributes"];
        for(id key in attributeDict) {
            IXMProductDescriptionAttributes *att = [[IXMProductDescriptionAttributes alloc] init];
            att.title = [self cleanKeyForTitle:key];
            att.value = [attributeDict objectForKey:key];
            [attributeArray addObject:att];
        }
        self.productDescriptionArray = attributeArray;
        
    }
    return self;
}


- (instancetype)initWithV2Model:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        self.name = [productDictionary objectForKey:@"title"];
        self.imageURL = [productDictionary objectForKey:@"imageUrl"];
        self.brandName = [productDictionary objectForKey:@"brandName"];
        self.categoryName = [productDictionary objectForKey:@"categoryName"];
        self.upcNumber = [IXMProductDetail commaSeperatedArray:[productDictionary objectForKey:@"upcs"]];
        self.mpnNumber = [IXMProductDetail commaSeperatedArray:[productDictionary objectForKey:@"mpns"]];
        
        
        
        NSMutableArray *attributeArray = [[NSMutableArray alloc] init];;
        NSDictionary *attributeDict = [productDictionary objectForKey:@"attributes"];
        for(id key in attributeDict) {
            IXMProductDescriptionAttributes *att = [[IXMProductDescriptionAttributes alloc] init];
            att.title = [self cleanKeyForTitle:key];
            NSArray *valueArray = [attributeDict objectForKey:key];
            att.value = [self cleanArrayForValue:valueArray];
            [attributeArray addObject:att];
        }
        self.productDescriptionArray = attributeArray;
        
    }
    return self;
}

- (NSString *)cleanArrayForValue:(NSArray *)array {
    if (array) {
        return [[array componentsJoinedByString:@"; "] capitalizedString];
    }
    return @"";
    
}

- (NSString *)cleanKeyForTitle:(NSString *)key {
    NSString *temp = [key stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return [temp capitalizedString];
}

- (NSString *)parseInformationFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    if ([dict objectForKey:key]) {
        NSString * obj = [dict objectForKey:key];
        if (![obj isEqualToString:@"NA"]) {
            return obj;
        }
    }
    return nil;
}

+ (NSString *)commaSeperatedArray:(NSArray *)array {
    if (array == nil || array.count == 0) {
        return nil;
    }
    return [array componentsJoinedByString:@","];
}

- (NSString *)commaSperatedSellerName {
    if (self.sellerNames == nil || self.sellerNames.count == 0) {
        return nil;
    }
    return [self.sellerNames componentsJoinedByString:@","];
}

@end

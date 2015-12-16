//  IXProduct.m
//  Indix Dynamo
//
//  Created by Senthil Kumar
//  Copyright (c) 2013 Indix. All rights reserved.
//

#import "IXProduct.h"
#import "IXRPriceTypeUtils.h"

@interface IXProduct ()

@end

@implementation IXProduct

+ (IXProduct *)productWithIdentifier:(NSString *)identifier name:(NSString *)name
{
    IXProduct *product = [[IXProduct alloc] init];
    product.pid = identifier;
    product.name = name;
    return product;
}

// As per indix api
- (instancetype)initWithProductModel:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        
        if ([productDictionary objectForKey:@"id"] != [NSNull null])
            self.pid = [productDictionary objectForKey:@"id"];
        self.mpid = [productDictionary objectForKey:@"mpid"];
        self.name = [productDictionary objectForKey:@"title"];
        
        if ([productDictionary objectForKey:@"offersPriceRange"] != [NSNull null]) {
            NSString *priceRange = [productDictionary objectForKey:@"offersPriceRange"];
            self.priceRange = [IXProduct patchProductPriceRange:priceRange];
        }
        
        
        if ([productDictionary objectForKey:@"imageUrl"] != [NSNull null])
            self.imageURL = [productDictionary objectForKey:@"imageUrl"];
        
        if ([productDictionary objectForKey:@"storeCount"] != [NSNull null])
            self.noOfStores = [productDictionary objectForKey:@"storeCount"];
        
        self.indixVersionType = @"v1";
        
    }
    return self;
}

- (instancetype)initWithV2ProductModel:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        
        if ([productDictionary objectForKey:@"id"] != [NSNull null])
            self.pid = [productDictionary objectForKey:@"id"];
        self.mpid = [productDictionary objectForKey:@"mpid"];
        self.name = [productDictionary objectForKey:@"title"];
        
        self.minSalePrice = [[productDictionary objectForKey:@"minSalePrice"] stringValue];
        self.maxSalePrice = [[productDictionary objectForKey:@"maxSalePrice"] stringValue];
        self.currency = [productDictionary objectForKey:@"currency"];
        
        self.priceRange = [NSString stringWithFormat:@"$%@ - $%@", self.minSalePrice, self.maxSalePrice];
        
        
        
//        if ([productDictionary objectForKey:@"offersPriceRange"] != [NSNull null]) {
//            NSString *priceRange = [productDictionary objectForKey:@"offersPriceRange"];
//            self.priceRange = [IXProduct patchProductPriceRange:priceRange];
//        }
        
        
        if ([productDictionary objectForKey:@"imageUrl"] != [NSNull null])
            self.imageURL = [productDictionary objectForKey:@"imageUrl"];
        
        if ([productDictionary objectForKey:@"storesCount"] != [NSNull null])
            self.noOfStores = [productDictionary objectForKey:@"storesCount"];
        
        if ([productDictionary objectForKey:@"categoryIdPath"] != [NSNull null])
            self.categoryIdPath = [productDictionary objectForKey:@"categoryIdPath"];
        
        if ([productDictionary objectForKey:@"categoryNamePath"] != [NSNull null])
            self.categoryNamePath = [productDictionary objectForKey:@"categoryNamePath"];
        
        self.indixVersionType = @"v2";
    }
    return self;
}

- (NSString *)priceRangeLabel {
    if (self.minSalePrice && self.maxSalePrice) {
        return [IXRPriceTypeUtils generatePriceRangeFromMinPrice:self.minSalePrice maxPrice:self.maxSalePrice currency:self.currency];
    }
    else {
        return [IXProduct patchProductPriceRange:self.priceRange];
    }
}

+ (NSString *)patchProductPriceRange:(NSString *)givenRange {
    NSArray* components = [givenRange componentsSeparatedByString: @"-"];
    // "29-29" or " 29 - 29" or "29"
    if (components && [components count] > 0) {
        if ([components count] == 1) {
            NSString *price = [[components objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([self isALLNumber:price]) {
                return [NSString stringWithFormat:@"$%@", price];
            }
        }
        else if ([components count] == 2) {
            NSString *price1 = [[components objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *price2 = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([self isALLNumber:price1] && [self isALLNumber:price2]) {
                if ([price1 isEqualToString:price2]) {
                    return [NSString stringWithFormat:@"$%@", price1];
                }
                else {
                    return [NSString stringWithFormat:@"$%@ - $%@", price1, price2];
                }
            }
            
        }
    }
    // Fallback return as it is
    return givenRange;
    
}

+ (BOOL)isALLNumber:(NSString *)string {
    float price_f = [string floatValue];
    if (price_f != 0.0) {
        return YES;
    }
    return NO;
}

- (NSArray *)allCategoryName {
    return [self parseCategoryStringToArray:self.categoryNamePath];
}

- (NSArray *)allCategoryId {
    return [self parseCategoryStringToArray:self.categoryIdPath];
}

- (NSArray *)parseCategoryStringToArray:(NSString *)string {
    NSArray * array = [string componentsSeparatedByString:@">"];
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (NSString *str in array) {
        [outputArray addObject:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    
    return outputArray;
}

@end

/*
 "products": [
 {
 "id": "fc9ae2b214c3054347850cfb2c6bb074",
 "mpid": "5806e337bf2ba9deed9ae2693a618281",
 "title": "Apple, Apple, Alligator: A...",
 "brandId": 1102,
 "brandName": "Apple",
 "categoryIdPath": "10172 > 18257 > 18527 > 23675",
 "categoryNamePath": "Toys & Games > Arts & Crafts > Drawing & Painting Supplies > Drawing & Sketch Pads",
 "imageUrl": "http://img1.imagesbn.com/p/9780761117872_p0_v2_s114x166.jpg",
 "upc": "9780761117872",
 "mpn": "NA",
 "storeCount": 1,
 "offersCount": 4,
 "offersPriceRange": "2.83-2.83"
 },
 */
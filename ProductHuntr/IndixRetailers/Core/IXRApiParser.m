//
//  IXRApiParser.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRApiParser.h"

@implementation IXRApiParser

+ (IXMProductDetail *)parseDetailFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"response"];
    
    IXMProductDetail *productDesc = [[IXMProductDetail alloc] initWithModel:responseObject];
    return productDesc;
}

+ (NSArray *)parsePriceDetailsFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"response"];
    
    NSArray *productoffersArray = [responseObject objectForKey:@"offers"];
    NSMutableArray *productPriceArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in productoffersArray) {
        [productPriceArray addObject:[[IXMProductPrice alloc] initWithModel:object]];
    }
    return productPriceArray;
}

+ (NSInteger)parseProductOfferCountFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"response"];
    return [[responseObject objectForKey:@"offersCount"] integerValue];
}

+ (NSArray *)parseProductArrayFromSearchDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"response"];
    
    NSArray *prodArray = [responseObject objectForKey:@"products"];
    NSMutableArray *prodmodalArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in prodArray) {
        IXProduct *product = [[IXProduct alloc] initWithProductModel:object];
        [prodmodalArray addObject:product];
    }
    return prodmodalArray;
}

+ (NSInteger)parseProductCountFromSearchDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"response"];
    NSInteger count = [[responseObject objectForKey:@"count"] integerValue];
    return count;
}

+ (NSArray *)parseSuggestionsFromDictionary:(NSDictionary *)responseObject {
    NSArray *response = [responseObject objectForKey:@"response"];
    
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in response) {
        [outputArray addObject:[object objectForKey:@"suggestion"]];
    }
    return outputArray;
}

@end

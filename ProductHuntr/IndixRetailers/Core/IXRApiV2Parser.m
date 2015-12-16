//
//  IXRApiV2Parser.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 16/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRApiV2Parser.h"

@implementation IXRApiV2Parser

+ (IXProduct *)parseProductFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *resultObject = [dictionary objectForKey:@"result"];
    NSDictionary *responseObject = [resultObject objectForKey:@"product"];
    IXProduct *product = [[IXProduct alloc] initWithV2ProductModel:responseObject];
    return product;
}

+ (IXMProductDetail *)parseDetailFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *resultObject = [dictionary objectForKey:@"result"];
    NSDictionary *responseObject = [resultObject objectForKey:@"product"];
    
    IXMProductDetail *productDesc = [[IXMProductDetail alloc] initWithV2Model:responseObject];
    return productDesc;
}

+ (NSArray *)parsePriceDetailsFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *resultObject = [dictionary objectForKey:@"result"];
    NSDictionary *responseObject = [resultObject objectForKey:@"product"];
    
    NSMutableArray *productPriceArray = [[NSMutableArray alloc] init];
    
    NSDictionary *allstoresDict = [responseObject objectForKey:@"stores"];
    for(id key in allstoresDict) {
        
        NSDictionary *storeDict = [allstoresDict objectForKey:key];
        NSArray *productoffersArray = [storeDict objectForKey:@"offers"];
        for (NSDictionary *object in productoffersArray) {
            [productPriceArray addObject:[[IXMProductPrice alloc] initWithV2Model:object storeDict:storeDict currency:[responseObject objectForKey:@"currency"]]];
        }
        
    }
    
    return productPriceArray;
}

+ (NSInteger)parseProductOfferCountFromProductDetailDictionary:(NSDictionary *)dictionary {
    NSDictionary *resultObject = [dictionary objectForKey:@"result"];
    NSDictionary *responseObject = [resultObject objectForKey:@"product"];
    return [[responseObject objectForKey:@"offersCount"] integerValue];
}

+ (NSArray *)parseProductArrayFromSearchDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"result"];
    
    NSArray *prodArray = [responseObject objectForKey:@"products"];
    NSMutableArray *prodmodalArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in prodArray) {
        IXProduct *product = [[IXProduct alloc] initWithV2ProductModel:object];
        [prodmodalArray addObject:product];
    }
    return prodmodalArray;
}

+ (IXMFilterObjects *)parseProductFilterFromSearchDictionary:(NSDictionary *)dictionary categoryTreeIndex:(NSInteger)treeIndex{
    NSDictionary *responseObject = [dictionary objectForKey:@"result"];
    
    NSDictionary *facets = [responseObject objectForKey:@"facets"];
    
    return [[IXMFilterObjects alloc] initWithV2ProductModel:facets categoryTreeIndex:treeIndex];
}

+ (NSInteger)parseProductCountFromSearchDictionary:(NSDictionary *)dictionary {
    NSDictionary *responseObject = [dictionary objectForKey:@"result"];
    NSInteger count = [[responseObject objectForKey:@"count"] integerValue];
    return count;
}

//+ (NSArray *)parseRecommendationFromDictionary:(NSArray *)dict {
//    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *object in dict) {
//        [outputArray addObject:[[IXMRecommendationData alloc] initWithV2ProductModel:object]];
//    }
//    
//    return outputArray;
//}

+ (NSArray *)parseSuggestionsFromDictionary:(NSDictionary *)responseObject {
    NSDictionary *response = [responseObject objectForKey:@"result"];
    NSArray *suggestionsArray = [response objectForKey:@"suggestions"];
    
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in suggestionsArray) {
        [outputArray addObject:[object objectForKey:@"suggestion"]];
    }
    return outputArray;
}

@end

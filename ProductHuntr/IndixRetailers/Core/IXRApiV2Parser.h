//
//  IXRApiV2Parser.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 16/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMProductPrice.h"
#import "IXMProductDetail.h"
#import "IXProduct.h"
#import "IXMFilterObjects.h"

@interface IXRApiV2Parser : NSObject

/**
 Helper methods to do Parsing for INDIX API V2
 */

+ (IXMProductDetail *)parseDetailFromProductDetailDictionary:(NSDictionary *)dictionary;
+ (NSArray *)parsePriceDetailsFromProductDetailDictionary:(NSDictionary *)dictionary;

+ (NSArray *)parseProductArrayFromSearchDictionary:(NSDictionary *)dictionary;
+ (NSInteger)parseProductCountFromSearchDictionary:(NSDictionary *)dictionary;
+ (IXMFilterObjects *)parseProductFilterFromSearchDictionary:(NSDictionary *)dictionary categoryTreeIndex:(NSInteger)treeIndex;

+ (NSInteger)parseProductOfferCountFromProductDetailDictionary:(NSDictionary *)dictionary;

+ (NSArray *)parseSuggestionsFromDictionary:(NSDictionary *)dict;

+ (IXProduct *)parseProductFromProductDetailDictionary:(NSDictionary *)dictionary;

//+ (NSArray *)parseRecommendationFromDictionary:(NSArray *)dict;


@end

//
//  IXRApiParser.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMProductPrice.h"
#import "IXMProductDetail.h"
#import "IXProduct.h"

@interface IXRApiParser : NSObject

/**
 Helper methods to do Parsing for INDIX API V1
 */

+ (IXMProductDetail *)parseDetailFromProductDetailDictionary:(NSDictionary *)dictionary;
+ (NSArray *)parsePriceDetailsFromProductDetailDictionary:(NSDictionary *)dictionary;

+ (NSArray *)parseProductArrayFromSearchDictionary:(NSDictionary *)dictionary;
+ (NSInteger)parseProductCountFromSearchDictionary:(NSDictionary *)dictionary;

+ (NSInteger)parseProductOfferCountFromProductDetailDictionary:(NSDictionary *)dictionary;


+ (NSArray *)parseSuggestionsFromDictionary:(NSDictionary *)dict;

@end

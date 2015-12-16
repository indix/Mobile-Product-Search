//
//  IXRetailerHelper.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRetailerHelper.h"
#import "IXApiV2Core.h"
#import "IXMFreshness.h"

#define PIN_NAME @"pin"

#define USER_DEFAULT_COUNTRY_CODE @"SELECTED_COUNTRY_CODE"
#define USER_DEFAULT_LAST_KNOWN_REFRESH_TIME @"LAST_KNOWN_REFRESH_TIME"
#define USER_DEFAULT_FILTERED_RESULT @"SELECTED_FILTERED_RESULT"
#define USER_DEFAULT_ASK_FEEDBACK @"SELECTED_ASK_FEEDBACK"
#define USER_DEFAULT_USER_FRESHNESS @"SELECTED_FRESHNESS"


NSString *const kIndixApiAppId = @"IndixApiAppId";
NSString *const kIndixApiAppkey = @"IndixApiAppkey";

NSInteger const kIXRMaxRecentSearchCount = 10;

@implementation IXRetailerHelper

#pragma mark - Settings
+ (void)requestSaveFreshness:(IXMFreshness *)alert {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:alert.days] forKey:USER_DEFAULT_USER_FRESHNESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (IXMFreshness *)requestFreshness {
    NSString *freshness_days = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_FRESHNESS];
    if (freshness_days) {
        return [IXMFreshness getFreshnessForKey:[freshness_days integerValue]];
    }
    else {
        return [IXMFreshness getDefaultFreshness];
    }
}

+ (void)requestSaveCountyCode:(IXMCountryCode *)code {
    [[NSUserDefaults standardUserDefaults] setObject:code.key forKey:USER_DEFAULT_COUNTRY_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (IXMCountryCode *)requestCountyCode {
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_COUNTRY_CODE];
    if (key) {
        return [IXMCountryCode getCountryCodeForKey:key];
    }
    else {
        return [IXMCountryCode getDefaultCountyCode];
    }
    
}


#pragma mark - Search Suggestion

/***
 
 @return NSArray of String of suggestion
 
 */
+ (void)requestSearchSuggestionForQuery:(NSString *)query withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *suggestions))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [IXApiV2Core requestSearchSuggestionForQuery:[self prepareSearchSuggestionParameterQueryWithQuery:query] withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *outputArray = [IXRApiV2Parser parseSuggestionsFromDictionary:responseObject];
        success(operation, outputArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

+ (NSMutableDictionary *)prepareSearchSuggestionParameterQueryWithQuery:(NSString *)query  {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    [queryParameter setObject:query forKey:@"query"];
    
    
    IXMCountryCode *countryCode = [self requestCountyCode];
    [queryParameter setObject:countryCode.key forKey:@"country_code"];
    return queryParameter;
}



#pragma mark - Search

// query :
// page : 1 and above
// result IXProduct array and count
+ (void)requestSKUSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    
    NSDictionary *queryParameter = [self prepareSearchParameterQueryWithQuery:query page:page sortBy:sortType settings:nil];
    
    [IXApiV2Core requestSKUSearchForQuery:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        NSInteger count = [IXRApiV2Parser parseProductCountFromSearchDictionary:outputObject];
        
        NSArray *prodmodalArray = [IXRApiV2Parser parseProductArrayFromSearchDictionary:outputObject];
        
        success(operation, prodmodalArray, count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

+ (void)requestMPNSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
   
    NSDictionary *queryParameter = [self prepareSearchParameterQueryWithQuery:query page:page sortBy:sortType settings:nil];
    
    [IXApiV2Core requestMPNSearchForQuery:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        NSInteger count = [IXRApiV2Parser parseProductCountFromSearchDictionary:outputObject];
        
        NSArray *prodmodalArray = [IXRApiV2Parser parseProductArrayFromSearchDictionary:outputObject];
        
        success(operation, prodmodalArray, count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

+ (void)requestUPCSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self prepareSearchParameterQueryWithQuery:query page:page sortBy:sortType settings:nil];
    
    [IXApiV2Core requestUPCSearchForQuery:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        
        NSInteger count = [IXRApiV2Parser parseProductCountFromSearchDictionary:outputObject];
        
        NSArray *prodmodalArray = [IXRApiV2Parser parseProductArrayFromSearchDictionary:outputObject];
        
        success(operation, prodmodalArray, count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

// settings
// filter_enabled [NSNumber -> bool]
// filter [IXMSelectedFilter]
// minOffers string
+ (void)requestGeneralSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count, IXMFilterObjects *filter))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *settingsDict = [self patchSettingsForQueryAndCategorySearch:settings];
    [self fetchSearchForQuery:query page:page sortBy:sortType settings:settingsDict withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
    
        NSInteger count = [IXRApiV2Parser parseProductCountFromSearchDictionary:outputObject];
        
        NSArray *prodmodalArray = [IXRApiV2Parser parseProductArrayFromSearchDictionary:outputObject];
        
        IXMFilterObjects *object = nil;
        if ([self isFilteringEnabledInSearch:settingsDict]) {
            object = [IXRApiV2Parser parseProductFilterFromSearchDictionary:outputObject categoryTreeIndex:0]; // 0 because of being top category
        }
        
        success(nil, prodmodalArray, count, object);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

+ (void)fetchSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id outputObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    NSDictionary *queryParameter = [self prepareSearchParameterQueryWithQuery:query page:page sortBy:sortType settings:settings];
    
    [IXApiV2Core requestGeneralSearchForQuery:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        
        
        success(operation, outputObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}


+ (NSMutableDictionary *)prepareParseSearchParameterQueryWithQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    if (query) {
        [queryParameter setObject:query forKey:@"query"];
    }
    
    [queryParameter setObject:@"10" forKey:@"count"];
    if (page) {
        [queryParameter setObject:page forKey:@"pageNumber"];
    }
    else {
        [queryParameter setObject:@"1" forKey:@"pageNumber"];
    }
    
    
    if (sortType) {
        if ([sortType.key isEqualToString:@"most_recent"]) {
            [queryParameter setValue:@"MOST_RECENT" forKey:@"sortOption"];
        }
        else if ([sortType.key isEqualToString:@"price_high_low"]) {
            [queryParameter setValue:@"PRICE_HIGH_TO_LOW" forKey:@"sortOption"];
        }
        else if ([sortType.key isEqualToString:@"price_low_high"]) {
            [queryParameter setValue:@"PRICE_LOW_TO_HIGH" forKey:@"sortOption"];
        }
    }
    
    
    IXMCountryCode *countryCode = [self requestCountyCode];
    [queryParameter setObject:countryCode.key forKey:@"countryCode"];
    
    IXMFreshness *freshness = [self requestFreshness];
    if (freshness.days > 0) {
        [queryParameter setObject:[NSNumber numberWithInteger:freshness.days] forKey:@"freshness"];
    }
    
    return queryParameter;
}

+ (NSMutableDictionary *)prepareSearchParameterQueryWithQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings {
    
    
    NSDictionary *params = [self updateSearchparameterWithPage:page sortBy:sortType settings:settings];
    
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (query) {
        [queryParameter setObject:query forKey:@"query"];
    }
    
    return queryParameter;
}

+ (BOOL) checkIfFilterByCategoriesIsAvaialbleInDict:(NSDictionary *)settingsDict {
    if ([settingsDict objectForKey:@"filter"]) {
        IXMSelectedFilters *selectedFilter = [settingsDict objectForKey:@"filter"];
        if (selectedFilter.selectedCategory.count > 0) {
            // do nothing
            return YES;
        }
    }
    return NO;
}

+ (NSMutableDictionary *)updateSearchparameterWithPage:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    [queryParameter setObject:@"10" forKey:@"count"];
    if (page) {
        [queryParameter setObject:page forKey:@"page"];
    }
    else {
        [queryParameter setObject:@"1" forKey:@"page"];
    }
    
    if (sortType != nil ){
        [queryParameter setObject:sortType forKey:@"sort_by"];
    }
    
    
    IXMCountryCode *countryCode = [self requestCountyCode];
    [queryParameter setObject:countryCode.key forKey:@"country_code"];
    
    IXMFreshness *freshness = [self requestFreshness];
    if (freshness.days > 0) {
        [queryParameter setObject:[NSNumber numberWithInteger:freshness.days] forKey:@"freshness"];
    }
    
    if (settings) {
        if ([settings objectForKey:@"filter_enabled"] && [[settings objectForKey:@"filter_enabled"] boolValue]) {
            [queryParameter setObject:@true forKey:@"filter_enabled"];
        }
        
        
        
        if ([settings objectForKey:@"minOffers"]) {
            [queryParameter setValue:[settings objectForKey:@"minOffers"] forKey:@"min_offer_count"];
        }
        
        if ([settings objectForKey:@"filter"]) {
            
            IXMSelectedFilters *selectedFilter = [settings objectForKey:@"filter"];
            if (selectedFilter.selectedCategory.count > 0) {
                NSArray *categoryFilter = selectedFilter.selectedCategory;
                NSMutableSet *set = [[NSMutableSet alloc] init];
                for (IXMCategoryFilter *object in categoryFilter) {
                    [set addObject:object.key];
                }
                [queryParameter setObject:set forKey:@"filter_by_categories"];
            }
            
            if (selectedFilter.selectedBrand.count > 0) {
                NSArray *filters = selectedFilter.selectedBrand;
                NSMutableSet *set = [[NSMutableSet alloc] init];
                for (IXMBrandFilter *object in filters) {
                    [set addObject:object.key];
                }
                [queryParameter setObject:set forKey:@"filter_by_brands"];
            }
            
            if (selectedFilter.selectedStores.count > 0) {
                NSArray *filters = selectedFilter.selectedStores;
                NSMutableSet *set = [[NSMutableSet alloc] init];
                for (IXMStoreFilter *object in filters) {
                    [set addObject:object.key];
                }
                [queryParameter setObject:set forKey:@"filter_by_stores"];
            }
            
            if (selectedFilter.availabilityFilterType) {
                NSString *given_availability = selectedFilter.availabilityFilterType;
                if (given_availability) {
                    if ([given_availability isEqualToString:kIXRAvailabilityInStock]) {
                        [queryParameter setValue:@"IN_STOCK" forKey:@"availability"];
                    }
                    else if ([given_availability isEqualToString:kIXRAvailabilityOutOfStock]) {
                        [queryParameter setValue:@"OUT_OF_STOCK" forKey:@"availability"];
                    }
                }
            }
            
            if (selectedFilter.minPrice > 0) {
                 [queryParameter setValue:[NSString stringWithFormat:@"%0.2f", selectedFilter.minPrice] forKey:@"startPrice"];
            }
            if (selectedFilter.maxPrice > 0 && selectedFilter.maxPrice > selectedFilter.minPrice) {
                [queryParameter setValue:[NSString stringWithFormat:@"%0.2f", selectedFilter.maxPrice] forKey:@"endPrice"];
            }
            
        }
        
    }
    
    return queryParameter;
}

+ (BOOL)isPaginationPossibleForPage:(NSInteger)page andTotalCount:(NSInteger)count {
    return [IXApiV2Core isPaginationPossibleForPage:page andTotalCount:count];
}

#pragma mark - Facets

+ (void)requestSubCategoryFacetsForQuery:(NSString *)query forCategory:(IXMCategoryFilter *)category withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSInteger count, IXMFilterObjects *filter))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *settingsDict = [self patchSettingsForQueryAndCategorySearch:nil];
    
    IXMSelectedFilters *support = [[IXMSelectedFilters alloc] init];
    [support addCategory:category];
    [settingsDict setValue:support forKey:@"filter"];
    
    [self fetchSearchForQuery:query page:nil sortBy:nil settings:settingsDict withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        NSInteger count = [IXRApiV2Parser parseProductCountFromSearchDictionary:outputObject];
        
        IXMFilterObjects *filter = [IXRApiV2Parser parseProductFilterFromSearchDictionary:outputObject categoryTreeIndex:category.treeIndex + 1];
        
        
        success(operation, count, filter);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}



+ (BOOL)isFilteringEnabledInSearch:(NSDictionary *)settings {
    return [settings objectForKey:@"filter_enabled"] && [[settings objectForKey:@"filter_enabled"] boolValue];
}

+ (NSMutableDictionary *)patchSettingsForQueryAndCategorySearch:(NSDictionary *)settings {
    NSMutableDictionary *outputDict = [[NSMutableDictionary alloc] init];
    if (settings) {
        [outputDict addEntriesFromDictionary:settings];
    }
    [outputDict setValue:@true forKey:@"filter_enabled"];
    return outputDict;
}

+ (void)retreiveRecentlySearchItemWithResult:(void (^)(NSArray *objects, NSError *error))result {
    NSArray *array = [IXMRecentSearchItem all];
    if (array) {
        result(array, nil);
    }
    else {
        result([[NSArray alloc] init], nil);
    }
}

+ (void)addRecentSearchItemWithQuery:(NSString *)queryString SearchType:(NSString *)searchTypeKeyword  result:(void (^)(BOOL success))result {
    NSArray *array = [IXMRecentSearchItem all];
    if (!array) {
        array = [[NSArray alloc] init];
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:array];
    
    NSString *lowercaseQuery = [queryString lowercaseString];
    // Remove if already exist and add back
    for (IXMRecentSearchItem *object in mutableArray) {
        if ([[object.query lowercaseString] isEqualToString:lowercaseQuery]) {
            if ([object.type isEqualToString:searchTypeKeyword]) {
                [mutableArray removeObject:object];
                break;
            }
        }
    }
    
    [mutableArray insertObject:[[IXMRecentSearchItem alloc] initWithQuery:queryString type:searchTypeKeyword] atIndex:0];
    
    NSInteger count = mutableArray.count;
    if (count > kIXRMaxRecentSearchCount) {
        count = kIXRMaxRecentSearchCount;
    }
    
    NSArray *smallArray = [mutableArray subarrayWithRange:NSMakeRange(0, count)];
    
    [IXMRecentSearchItem replaceWithRecentSearch:smallArray];
    result(YES);
}

#pragma mark - Product Catalog and Offer

+ (void)requestProductCatalogForProductUsingMPid:(NSString *)mpid withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, IXProduct *product, IXMProductDetail *productDesc, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryparameter = [[NSMutableDictionary alloc] init];
    [queryparameter setObject:mpid forKey:@"mpid"];
    IXMCountryCode *countryCode = [self requestCountyCode];
    [queryparameter setObject:countryCode.key forKey:@"country_code"];
    
    [IXApiV2Core requestProductDescriptionForQuery:queryparameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        IXProduct *product = [IXRApiV2Parser parseProductFromProductDetailDictionary:outputObject];
        IXMProductDetail *productDesc = [IXRApiV2Parser parseDetailFromProductDetailDictionary:outputObject];
        NSArray *productPriceArray = [IXRApiV2Parser parsePriceDetailsFromProductDetailDictionary:outputObject];
        NSInteger offerCount = [IXRApiV2Parser parseProductOfferCountFromProductDetailDictionary:outputObject];
        
        success(operation, product, productDesc, productPriceArray, offerCount);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


+ (void)requestProductCatalogForProduct:(IXProduct *)product withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, IXMProductDetail *productDesc, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryparameter = [[NSMutableDictionary alloc] init];
    if (product.pid) {
        [queryparameter setObject:product.pid forKey:@"pid"];
    }
    [queryparameter setObject:product.mpid forKey:@"mpid"];
    IXMCountryCode *countryCode = [self requestCountyCode];
    [queryparameter setObject:countryCode.key forKey:@"country_code"];
    
    [IXApiV2Core requestProductDescriptionForQuery:queryparameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        IXMProductDetail *productDesc = [IXRApiV2Parser parseDetailFromProductDetailDictionary:outputObject];
        NSArray *productPriceArray = [IXRApiV2Parser parsePriceDetailsFromProductDetailDictionary:outputObject];
        NSInteger offerCount = [IXRApiV2Parser parseProductOfferCountFromProductDetailDictionary:outputObject];
        
        success(operation, productDesc, productPriceArray, offerCount);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+ (BOOL)isPaginationPossibleForOffersInStores:(NSInteger)page andTotalCount:(NSInteger)count {
    return [IXApiV2Core isPaginationPossibleForOffersInStore:page andTotalCount:count];
}

+ (void)requestProductOffersForProduct:(IXProduct *)product page:(NSString *)page withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryparameter = [[NSMutableDictionary alloc] init];
    if (product.pid) {
        [queryparameter setObject:product.pid forKey:@"pid"];
    }
    [queryparameter setObject:product.mpid forKey:@"mpid"];
    if (page) {
        [queryparameter setObject:page forKey:@"page"];
    }
    
    [IXApiV2Core requestProductDescriptionForQuery:queryparameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id outputObject) {
        
        NSArray *productPriceArray = [IXRApiV2Parser parsePriceDetailsFromProductDetailDictionary:outputObject];
        NSInteger offerCount = [IXRApiV2Parser parseProductOfferCountFromProductDetailDictionary:outputObject];
        
        success(operation, productPriceArray, offerCount);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


// For testing

+ (AFHTTPRequestOperationManager *)getRequestOperationManager {
    AFHTTPRequestOperationManager * manager = [IXApiV2Core prepareHttpRequestManager];
    return manager;
}

@end

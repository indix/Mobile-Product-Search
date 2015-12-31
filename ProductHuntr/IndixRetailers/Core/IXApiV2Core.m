//
//  IXApiV2Core.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 16/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXApiV2Core.h"

NSString *const kIXAPIV2ServiceTokenAPIID = @"IXAPIServiceTokenAPIID";
NSString *const kIXAPIV2ServiceTokenAPIKey = @"IXAPIServiceTokenAPIKey";

NSString *const kIXAPIV2BaseURL = @"https://api.indix.com";
NSString *const kIXAPIV2GetParameterAPIID = @"app_id";
NSString *const kIXAPIV2GetParameterAPIKEY = @"app_key";

NSString *const kIXAPIV2SearchSuggestionEndPoint = @"/v2/products/suggestions";
NSString *const kIXAPIV2SearchProductsEndPoint = @"/v2/summary/products";

NSString *const kIXAPIV2ProductDescriptionEndPoint = @"/v2/universal/products/%@";
NSInteger const kIXAPIV2ProductCount = 10;

@implementation IXApiV2Core

+ (NSString *)getServiceTokenAppId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceTokenId = [defaults stringForKey:kIXAPIV2ServiceTokenAPIID];
    return serviceTokenId;
}

+ (NSString *)getServiceTokenAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceTokenId = [defaults stringForKey:kIXAPIV2ServiceTokenAPIKey];
    return serviceTokenId;
}

+ (void)setServiceTokenId:(NSString *)appId appKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appId forKey:kIXAPIV2ServiceTokenAPIID];
    [defaults setObject:key forKey:kIXAPIV2ServiceTokenAPIKey];
    [defaults synchronize];
}

+ (AFHTTPRequestOperation *)requestSearchSuggestionForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToSearchSuggestion:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"q"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchSuggestionEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (NSMutableDictionary *)patchQueryToSearchSuggestion:(NSDictionary *)dictionary {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    if ([dictionary objectForKey:@"country_code"]) {
        [queryParameter setValue:[dictionary objectForKey:@"country_code"] forKey:@"countryCode"];
    }
    else {
        [queryParameter setValue:@"US" forKey:@"countryCode"];
    }
    return queryParameter;
}

// query and patch
+ (AFHTTPRequestOperation *)requestSKUSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearchUsingNumber:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"sku"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestMPNSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearchUsingNumber:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"mpn"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestUPCSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearchUsingNumber:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"upc"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestURLSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearchUsingNumber:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"url"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestGeneralSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryParameter = [self patchQueryToProductSearch:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"q"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestCategorySearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryParameter = [self patchQueryToCategorySearch:dictionary];
    
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPIV2SearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

// pageNumber = 1 and above
// sortBy = PRICE_LOW_TO_HIGH, PRICE_HIGH_TO_LOW, MOST_RECENT
// count = 10 by default
// filter_enabled = true/false
// filter_by_categories -> sets
// filter_by_brands -> sets
// filter_by_stores -> sets
+ (NSMutableDictionary *)patchQueryToProductSearch:(NSDictionary *)dictionary {
    NSDictionary *params = [self patchPlainToProductSearch:dictionary];
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if ([dictionary objectForKey:@"filter_enabled"] && [[dictionary objectForKey:@"filter_enabled"] boolValue]) {
        [queryParameter setValue:[NSSet setWithObjects:@"categoryId", @"storeId", @"brandId", nil] forKey:@"facetBy"];
    }
    
    
    return queryParameter;
}

+ (NSMutableDictionary *)patchQueryToCategorySearch:(NSDictionary *)dictionary {
    NSDictionary *params = [self patchPlainToProductSearch:dictionary];
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if ([dictionary objectForKey:@"filter_enabled"] && [[dictionary objectForKey:@"filter_enabled"] boolValue]) {
        [queryParameter setValue:[NSSet setWithObjects:@"categoryId",  nil] forKey:@"facetBy"];
    }
    
    
    return queryParameter;
}


+ (NSMutableDictionary *)patchPlainToProductSearch:(NSDictionary *)dictionary {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    if ([dictionary objectForKey:@"page"]) {
        [queryParameter setValue:[dictionary objectForKey:@"page"] forKey:@"pageNumber"];
    }
    
    if ([dictionary objectForKey:@"sort_by"]) {
        IXMSortType *sortType = [dictionary objectForKey:@"sort_by"];
        if ([sortType.key isEqualToString:@"most_recent"]) {
            [queryParameter setValue:@"MOST_RECENT" forKey:@"sortBy"];
        }
        else if ([sortType.key isEqualToString:@"price_high_low"]) {
            [queryParameter setValue:@"PRICE_HIGH_TO_LOW" forKey:@"sortBy"];
        }
        else if ([sortType.key isEqualToString:@"price_low_high"]) {
            [queryParameter setValue:@"PRICE_LOW_TO_HIGH" forKey:@"sortBy"];
        }
    }
    
    if ([dictionary objectForKey:@"min_offer_count"]) {
        [queryParameter setValue:[dictionary objectForKey:@"min_offer_count"] forKey:@"storesCount"];
    }
    
    if ([dictionary objectForKey:@"country_code"]) {
        [queryParameter setValue:[dictionary objectForKey:@"country_code"] forKey:@"countryCode"];
    }
    else {
        [queryParameter setValue:@"US" forKey:@"countryCode"];
    }
    
    if ([dictionary objectForKey:@"freshness"]) {
        [queryParameter setValue:[dictionary objectForKey:@"freshness"] forKey:@"lastRecordedIn"];
    }
    
    [queryParameter setValue:[NSString stringWithFormat:@"%ld", (long)kIXAPIV2ProductCount] forKey:@"pageSize"];
    
    
    if ([dictionary objectForKey:@"availability"]) {
        [queryParameter setValue:[dictionary objectForKey:@"availability"] forKey:@"availability"];
    }
    
    if ([dictionary objectForKey:@"startPrice"]) {
        [queryParameter setValue:[dictionary objectForKey:@"startPrice"] forKey:@"startPrice"];
    }
    
    if ([dictionary objectForKey:@"endPrice"]) {
        [queryParameter setValue:[dictionary objectForKey:@"endPrice"] forKey:@"endPrice"];
    }
    
    if ([dictionary objectForKey:@"filter_by_categories"]) {
        NSSet *set = [dictionary objectForKey:@"filter_by_categories"];
        if ([set count] > 0) {
            [queryParameter setValue:[dictionary objectForKey:@"filter_by_categories"] forKey:@"categoryId"];
            
        }
    }
    
    if ([dictionary objectForKey:@"filter_by_brands"]) {
        NSSet *set = [dictionary objectForKey:@"filter_by_brands"];
        if ([set count] > 0) {
            [queryParameter setValue:[dictionary objectForKey:@"filter_by_brands"] forKey:@"brandId"];
            
        }
    }
    
    if ([dictionary objectForKey:@"filter_by_stores"]) {
        NSSet *set = [dictionary objectForKey:@"filter_by_stores"];
        if ([set count] > 0) {
            [queryParameter setValue:[dictionary objectForKey:@"filter_by_stores"] forKey:@"storeId"];
        }
        
        
    }
    
    
    return queryParameter;
}


+ (NSMutableDictionary *)patchQueryToProductSearchUsingNumber:(NSDictionary *)dictionary {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    if ([dictionary objectForKey:@"country_code"]) {
        [queryParameter setValue:[dictionary objectForKey:@"country_code"] forKey:@"countryCode"];
    }
    else {
        [queryParameter setValue:@"US" forKey:@"countryCode"];
    }
    return queryParameter;
}

+ (BOOL)isPaginationPossibleForPage:(NSInteger)page andTotalCount:(NSInteger)count {
    
    NSInteger firstItem = (page - 1) * kIXAPIV2ProductCount + 1;
    if (firstItem <= count) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPaginationPossibleForOffersInStore:(NSInteger)page andTotalCount:(NSInteger)count {
    
    NSInteger firstItem = (page - 1) * 50 + 1;
    if (firstItem <= count) {
        return YES;
    }
    return NO;
}

// pid - *
+ (AFHTTPRequestOperation *)requestProductDescriptionForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryParameter = [self patchQueryToProductDescription:dictionary];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:[NSString stringWithFormat:kIXAPIV2ProductDescriptionEndPoint, [dictionary objectForKey:@"mpid"]] parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

// type - default
+ (NSMutableDictionary *)patchQueryToProductDescription:(NSDictionary *)dictionary {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    
    
    if ([dictionary objectForKey:@"page"]) {
        [queryParameter setValue:[dictionary objectForKey:@"page"] forKey:@"pageNumber"];
    }
    
    if ([dictionary objectForKey:@"country_code"]) {
        [queryParameter setValue:[dictionary objectForKey:@"country_code"] forKey:@"countryCode"];
    }
    else {
        [queryParameter setValue:@"US" forKey:@"countryCode"];
    }
    
    return queryParameter;
}


+ (AFHTTPRequestOperation *)httpGetRequestForEndPoint:(NSString *)url parameter:(NSDictionary *)parameter withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = operationManger;
    if (!manager) {
        manager = [self prepareHttpRequestManager];
    }
    
    NSMutableDictionary *getparams = [[NSMutableDictionary alloc] init];
    if (parameter) {
        [getparams addEntriesFromDictionary:parameter];
    }
    [getparams setObject:[self getServiceTokenAppId] forKey:kIXAPIV2GetParameterAPIID];
    [getparams setObject:[self getServiceTokenAppKey] forKey:kIXAPIV2GetParameterAPIKEY];
    
    AFHTTPRequestOperation * operation = [manager GET:url parameters:getparams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    
    return operation;
}

+ (AFHTTPRequestOperationManager *)prepareHttpRequestManager {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kIXAPIV2BaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // [manager.requestSerializer setValue:@"calvinAndHobbessRock" forHTTPHeaderField:@"X-I do what I want"];
    return manager;
}

@end

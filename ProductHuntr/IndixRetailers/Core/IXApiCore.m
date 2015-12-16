//
//  IXApiCore.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXApiCore.h"


NSString *const kIXAPIServiceTokenAPIID = @"IXAPIServiceTokenAPIID";
NSString *const kIXAPIServiceTokenAPIKey = @"IXAPIServiceTokenAPIKey";

NSString *const kIXAPIBaseURL = @"https://api.indix.com";
NSString *const kIXAPIGetParameterAPIID = @"app_id";
NSString *const kIXAPIGetParameterAPIKEY = @"app_key";

NSString *const kIXAPISearchSuggestionEndPoint = @"/v1/products/suggestions";
NSString *const kIXAPISearchProductsEndPoint = @"/v1/products";

NSString *const kIXAPIProductDescriptionEndPoint = @"/v1/products/%@";


@implementation IXApiCore

+ (NSString *)getServiceTokenAppId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceTokenId = [defaults stringForKey:kIXAPIServiceTokenAPIID];
    return serviceTokenId;
}

+ (NSString *)getServiceTokenAppKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceTokenId = [defaults stringForKey:kIXAPIServiceTokenAPIKey];
    return serviceTokenId;
}

+ (void)setServiceTokenId:(NSString *)appId appKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appId forKey:kIXAPIServiceTokenAPIID];
    [defaults setObject:key forKey:kIXAPIServiceTokenAPIKey];
    [defaults synchronize];
}

+ (AFHTTPRequestOperation *)requestSearchSuggestionForQuery:(NSString *)query withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = @{@"query":query};
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPISearchSuggestionEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

// query and patch
+ (AFHTTPRequestOperation *)requestSKUSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
 
    NSDictionary *queryParameter = [self patchQueryToProductSearch:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"sku"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPISearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestMPNSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearch:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"mpn"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPISearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestUPCSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *queryParameter = [self patchQueryToProductSearch:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"upc"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPISearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestGeneralSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryParameter = [self patchQueryToProductSearch:dictionary];
    [queryParameter setValue:[dictionary objectForKey:@"query"] forKey:@"query"];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:kIXAPISearchProductsEndPoint parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

// pageNumber = 1 and above
// sortBy = PRICE_LOW_TO_HIGH, PRICE_HIGH_TO_LOW, MOST_RECENT
// count = 10 by default
+ (NSMutableDictionary *)patchQueryToProductSearch:(NSDictionary *)dictionary {
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
        [queryParameter setValue:[dictionary objectForKey:@"min_offer_count"] forKey:@"offersCount"];
    }
    return queryParameter;
}

+ (BOOL)isPaginationPossibleForPage:(NSInteger)page andTotalCount:(NSInteger)count {
    
    NSInteger firstItem = (page - 1) * 10 + 1;
    if (firstItem <= count) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPaginationPossibleForOffersInStore:(NSInteger)page andTotalCount:(NSInteger)count {
    
    NSInteger firstItem = (page - 1) * 10 + 1;
    if (firstItem <= count) {
        return YES;
    }
    return NO;
}

// pid - *
+ (AFHTTPRequestOperation *)requestProductDescriptionForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *queryParameter = [self patchQueryToProductDescription:dictionary];
    
    AFHTTPRequestOperation * operation = [self httpGetRequestForEndPoint:[NSString stringWithFormat:kIXAPIProductDescriptionEndPoint, [dictionary objectForKey:@"pid"]] parameter:queryParameter withManager:operationManger success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return operation;
}

// type - default
+ (NSMutableDictionary *)patchQueryToProductDescription:(NSDictionary *)dictionary {
    NSMutableDictionary *queryParameter = [[NSMutableDictionary alloc] init];
    if ([dictionary objectForKey:@"type"]) {
        [queryParameter setObject:[dictionary objectForKey:@"type"] forKey:@"view"];
    }
    
    if ([dictionary objectForKey:@"page"]) {
        [queryParameter setValue:[dictionary objectForKey:@"page"] forKey:@"pageNumber"];
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
    [getparams setObject:[self getServiceTokenAppId] forKey:kIXAPIGetParameterAPIID];
    [getparams setObject:[self getServiceTokenAppKey] forKey:kIXAPIGetParameterAPIKEY];
    
    AFHTTPRequestOperation * operation = [manager GET:url parameters:getparams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    
    return operation;
}

+ (AFHTTPRequestOperationManager *)prepareHttpRequestManager {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kIXAPIBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // [manager.requestSerializer setValue:@"calvinAndHobbessRock" forHTTPHeaderField:@"X-I do what I want"];
    return manager;
}


@end

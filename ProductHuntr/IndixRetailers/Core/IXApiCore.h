//
//  IXApiCore.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "IXMSortType.h"

extern NSString * const kIXAPISearchSuggestionEndPoint;

@interface IXApiCore : NSObject

/**
 Helper methods to do API call from INDIX API V1
 */

// App ID and Key to make this api work
+ (NSString *)getServiceTokenAppId;
+ (NSString *)getServiceTokenAppKey;
+ (void)setServiceTokenId:(NSString *)appId appKey:(NSString *)key;

// Search Suggestions
+ (AFHTTPRequestOperation *)requestSearchSuggestionForQuery:(NSString *)query withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Search
// query - string
+ (AFHTTPRequestOperation *)requestSKUSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)requestMPNSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)requestUPCSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)requestGeneralSearchForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (BOOL)isPaginationPossibleForPage:(NSInteger)page andTotalCount:(NSInteger)count;



// product details
// type - offers_catalog
// pid - product id
+ (AFHTTPRequestOperation *)requestProductDescriptionForQuery:(NSDictionary *)dictionary withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (NSMutableDictionary *)patchQueryToProductDescription:(NSDictionary *)dictionary;

+ (BOOL)isPaginationPossibleForOffersInStore:(NSInteger)page andTotalCount:(NSInteger)count;

// Rest methods
+ (AFHTTPRequestOperationManager *)prepareHttpRequestManager;
+ (AFHTTPRequestOperation *)httpGetRequestForEndPoint:(NSString *)url parameter:(NSDictionary *)parameter withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// Testing
+ (NSMutableDictionary *)patchQueryToProductSearch:(NSDictionary *)dictionary;

@end

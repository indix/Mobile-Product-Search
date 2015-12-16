//
//  IXRetailerHelper.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "IXProduct.h"
#import "IXMSortType.h"
#import "IXMProductDetail.h"
#import "IXMProductPrice.h"
#import "IXMSearchType.h"
#import "IXMRecentSearchItem.h"
#import "IXRApiV2Parser.h"
#import "IXMCountryCode.h"
#import "IXMFreshness.h"
#import "IXMCategoryFilter.h"
#import "IXMBrandFilter.h"
#import "IXMStoreFilter.h"
#import "IXMFilterObjects.h"
#import "IXMSelectedFilters.h"


@interface IXRetailerHelper : NSObject

/**
    Helper methods that UI uses to get data from server. It seperates server code from UI so you can feel free to change the server to whatever you want.
 */

// Search Suggestion
+ (void)requestSearchSuggestionForQuery:(NSString *)query withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *suggestions))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestProductCatalogForProductUsingMPid:(NSString *)mpid withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, IXProduct *product,IXMProductDetail *productDesc, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// Search
+ (void)requestSKUSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestMPNSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)requestUPCSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)requestGeneralSearchForQuery:(NSString *)query page:(NSString *)page sortBy:(IXMSortType *)sortType settings:(NSDictionary *)settings withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count, IXMFilterObjects *filter))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (BOOL)isPaginationPossibleForPage:(NSInteger)page andTotalCount:(NSInteger)count;

+ (void)requestSubCategoryFacetsForQuery:(NSString *)query forCategory:(IXMCategoryFilter *)category withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSInteger count, IXMFilterObjects *filter))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Recent Search
+ (void)addRecentSearchItemWithQuery:(NSString *)query SearchType:(NSString *)searchTypeKeyword result:(void (^)(BOOL success))result;
+ (void)retreiveRecentlySearchItemWithResult:(void (^)(NSArray *objects, NSError *error))result;

// product details
+ (void)requestProductCatalogForProduct:(IXProduct *)product withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, IXMProductDetail *productDesc, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (BOOL)isPaginationPossibleForOffersInStores:(NSInteger)page andTotalCount:(NSInteger)count;
+ (void)requestProductOffersForProduct:(IXProduct *)product page:(NSString *)page withManager:(AFHTTPRequestOperationManager *)operationManger success:(void (^)(AFHTTPRequestOperation *operation, NSArray * productprices, NSInteger offerCount))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// CountyCode
+ (void)requestSaveCountyCode:(IXMCountryCode *)code;
+ (IXMCountryCode *)requestCountyCode;


+ (void)requestSaveFreshness:(IXMFreshness *)alert;
+ (IXMFreshness *)requestFreshness;



// For testing

+ (AFHTTPRequestOperationManager *)getRequestOperationManager;

@end

//
//  IXRCatalogParentImplViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXProduct.h"
#import "IXRCatalogViewController.h"

@protocol IXRCatalogParentImplViewControllerDelegate;

@interface IXRCatalogParentImplViewController : UIViewController

/**
 View Controller to implement Tab-bar controller. 
 */

@property (nonatomic, weak) IXRCatalogViewController* parentVC;
@property (nonatomic, readonly, strong) IXMProductDetail *productDetail;
@property (nonatomic, readonly, strong) NSString *productTitle;
@property (nonatomic, readonly, strong) NSArray *productPriceArray;
@property (nonatomic, readonly, assign) NSInteger totalPriceOfferCount;
@property (nonatomic, readonly, assign) NSInteger pricePageNumber;

@property (nonatomic, readonly, strong) IXProduct *product;


- (BOOL)isFetchingProductinformation;
- (NSString *)productOffers;
- (NSString *)storeCount;

- (void)doShowAllPrices;

- (void)addPricesFromArray:(NSArray *)productprices forPage:(NSInteger)page;

@end

@protocol IXRCatalogParentImplViewControllerDelegate <NSObject>

@required



@optional
- (void)startingProductDetailfetch;
- (void)productDetailfetchFinished:(BOOL)isSuccess;

- (void)startingFavoritesChange;
- (void)favoritesChangeFinished:(BOOL)isSuccess;

@end

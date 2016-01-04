//
//  IXRCatalogViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXProduct.h"
#import "IXMProductDetail.h"
#import "IXMProductPrice.h"
#import "IXMSavedProduct.h"


@interface IXRCatalogViewController : UIViewController

/**
 ViewController to show Details of products
 */

// Public
@property (nonatomic, strong) IXProduct *product;
@property (nonatomic, strong) NSString *mixPanelSearchDescription;
@property (nonatomic, assign) NSInteger searchPosition;
@property (nonatomic, strong) NSString *productMPid;


// Child
@property (nonatomic, assign) BOOL isFetchingProductDetails;

@property (nonatomic, strong) IXMProductDetail *productDescription;
@property (nonatomic, strong) NSMutableArray *priceAcrossStores;
@property (nonatomic, assign) NSInteger totalPriceOfferCount;
@property (nonatomic, assign) NSInteger pricePageNumber;


@property (nonatomic, strong) IXMSavedProduct *savedProductDetails;
@property (nonatomic, assign) BOOL isRefreshingFavoritesDetails;
@property (nonatomic, assign, readonly) BOOL isSavedToFavorites;


- (void)addPricesFromArray:(NSArray *)productprices forPage:(NSInteger)page;
- (void)changeFavoritesState;
- (void)switchSegmentToPrice;

@end

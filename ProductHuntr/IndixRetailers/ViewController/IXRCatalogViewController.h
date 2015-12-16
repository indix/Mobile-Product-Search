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


@interface IXRCatalogViewController : UIViewController

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

- (void)addPricesFromArray:(NSArray *)productprices forPage:(NSInteger)page;

- (void)switchSegmentToPrice;

@end

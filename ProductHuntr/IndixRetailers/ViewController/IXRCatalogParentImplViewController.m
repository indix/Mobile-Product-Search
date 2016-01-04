//
//  IXRCatalogParentImplViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCatalogParentImplViewController.h"

@interface IXRCatalogParentImplViewController ()

@end

@implementation IXRCatalogParentImplViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IXProduct *)product {
    return self.parentVC.product;
}

- (NSString *)productTitle {
    return self.parentVC.product.name;
}

- (NSString *)productOffers {
    return self.parentVC.product.priceRangeLabel;
}

- (NSString *)storeCount {
    return self.parentVC.product.noOfStores;
}

- (NSArray *)productPriceArray {
    return self.parentVC.priceAcrossStores;
}

- (NSInteger)totalPriceOfferCount {
    return self.parentVC.totalPriceOfferCount;
}

- (NSInteger)pricePageNumber {
    return self.parentVC.pricePageNumber;
}

- (BOOL)isFetchingProductinformation {
    return self.parentVC.isFetchingProductDetails;
}

- (IXMProductDetail *)productDetail {
    return self.parentVC.productDescription;
}

- (void)doShowAllPrices {
    [self.parentVC switchSegmentToPrice];
}

- (void)addPricesFromArray:(NSArray *)productprices forPage:(NSInteger)page {
    [self.parentVC addPricesFromArray:productprices forPage:page];
}

- (BOOL)isDoingFavouriting {
    return self.parentVC.isRefreshingFavoritesDetails;
}

- (BOOL)isAddedtoFavorites {
    return self.parentVC.isSavedToFavorites;
}

- (void)doToggleFavoritesOption {
    [self.parentVC changeFavoritesState];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

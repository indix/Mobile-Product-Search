//
//  ViewController.m
//  ProductHuntr
//
//  Created by Nalin Chhajer on 15/12/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import "ViewController.h"
#import "IndixRetailers.h"
#import "IXRSearchBarHolderView.h"
#import "UIImageEffects.h"

@interface ViewController ()<IXRSearchBarHolderViewDelegate, IXScannerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet IXRSearchBarHolderView *searchBarholder;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homeAppLogo;

@property (nonatomic, strong) UIStoryboard *retailerStoryboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
    self.searchBarholder.delegate = self;
    
    UIImage* backgroundImage = [UIImage imageNamed:[[IXRTheme instance] homeScreenBlurredBackgroundImage]];
    UIImage *blurredBackgroundImage = [UIImageEffects imageByApplyingBlurToImage:backgroundImage withRadius:25.0 tintColor:[[IXRTheme instance] homeScreenBlurredBackgroundTintColor] saturationDeltaFactor:1.5 maskImage:nil];
    self.backgroundImageView.image = blurredBackgroundImage;
    
    self.homeAppLogo.image = [UIImage imageNamed:[[IXRTheme instance] homeAppLogoImage]];
    self.retailerStoryboard = [IXRViewControllerHelper retailerStoryboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showScannerViewController {
    IXScannerViewController *vc = [IXRViewControllerHelper scannerViewController:self.retailerStoryboard];
    vc.title = @"Scan Barcode";
    vc.scanDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSearchViewController {
    
    IXRSearchDisplayViewController *searchVc = [IXRViewControllerHelper searchDisplayViewController:self.retailerStoryboard];
    searchVc.isFromHomeViewController = YES;
    searchVc.homeSearchRect = [self.view convertRect:self.searchBarholder.searchBar.bounds fromView:self.searchBarholder.searchBar];
    
    [IXRViewControllerHelper startAViewControllerWithBlurredBackground:self destinationViewController:searchVc completion:^(UIImageView * blurredImageView, BOOL finished) {
        searchVc.blurredImageView = blurredImageView;
        [self.navigationController pushViewController:searchVc animated:NO];
    }];
    
}

- (void)foundBarCodeWithId:(NSString *)barcodeId {
    [self.navigationController popViewControllerAnimated:YES];
    
    // Save in recent searches if it is success.
    IXRProductListViewController *productVC = [IXRViewControllerHelper productListViewController:self.retailerStoryboard];
    IXMSearchType *searchType = [IXMSearchType getSearchtypeForKey:kIXRSearchTypeUPC];
    productVC.searchtype = searchType;
    productVC.searchQuery = barcodeId;
    productVC.saveSearchOnSuccess = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}

@end

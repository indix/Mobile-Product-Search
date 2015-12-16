//
//  IXRViewControllerHelper.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 28/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXRSelectChoiceViewController.h"
#import "IXScannerViewController.h"
#import "IXRProductListViewController.h"
#import "IXRSearchDisplayViewController.h"

@interface IXRViewControllerHelper : NSObject

/**
    Helper class to call right view controllers and call them with parameters
 */

+ (UINavigationController *)settingChoiceViewController:(UIStoryboard *)storyboard;
+ (IXScannerViewController *)scannerViewController:(UIStoryboard *)storyboard;
+ (IXRProductListViewController *)productListViewController:(UIStoryboard *)storyboard;
+ (IXRSearchDisplayViewController *)searchDisplayViewController:(UIStoryboard *)storyboard;


+ (void)startAViewControllerWithBlurredBackground:(UIViewController *)sourceVC destinationViewController:(UIViewController *)destinationVC completion:(void (^)(UIImageView * blurredImageView, BOOL finished))completion ;

+ (UIStoryboard *)retailerStoryboard;

@end

//
//  IXRViewControllerHelper.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 28/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRViewControllerHelper.h"
#import "UIImageEffects.h"

@implementation IXRViewControllerHelper



+ (IXRSearchDisplayViewController *)searchDisplayViewController:(UIStoryboard *)storyboard {
    IXRSearchDisplayViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchDisplayVC"];
    return controller;
}

+ (IXScannerViewController *)scannerViewController:(UIStoryboard *)storyboard {
    IXScannerViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"scannerVC"];
    return controller;
}



+ (UINavigationController *)settingChoiceViewController:(UIStoryboard *)storyboard {
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"selectChoiceNavVC"];
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    return controller;
}



+ (IXRProductListViewController *)productListViewController:(UIStoryboard *)storyboard {
    IXRProductListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"productListVC"];
    return controller;
}

+ (IXRCatalogViewController *)catalogViewControllerWithProduct:(IXMSavedProduct *)saved_product storyboard:(UIStoryboard *)storyboard {
    IXRCatalogViewController *catalogVC = [storyboard instantiateViewControllerWithIdentifier:@"catalogVC"];
    catalogVC.product = [saved_product copyOFProduct];
    return catalogVC;
}

+ (IXRCatalogViewController *)catalogViewControllerWithProductMpid:(NSString *)mpid storyboard:(UIStoryboard *)storyboard {
    IXRCatalogViewController *catalogVC = [storyboard instantiateViewControllerWithIdentifier:@"catalogVC"];
    catalogVC.productMPid = mpid;
    return catalogVC;
}

+ (UIStoryboard *)retailerStoryboard {
    return [UIStoryboard storyboardWithName:@"IndixRetailer" bundle:nil];
}

#pragma mark utilities


+ (void)startAViewControllerWithBlurredBackground:(UIViewController *)sourceVC destinationViewController:(UIViewController *)destinationVC completion:(void (^)(UIImageView * blurredImageView, BOOL finished))completion {
    
    UIView *destinationView = destinationVC.view;
    destinationView.backgroundColor = [UIColor clearColor];
    UIView *sourceView = sourceVC.view;
    
    // Create blurred image
    UIImage *screenshot = [self screenshotsOfView:sourceView];
    UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, sourceView.frame.size.height, sourceView.frame.size.width, 0.0)];
    blurredImageView.clipsToBounds = YES;
    blurredImageView.contentMode = UIViewContentModeBottom;
    
    // Add blurred image
    UIImage *blurredImage = [UIImageEffects imageByApplyingExtraLightEffectToImage:screenshot];
    blurredImageView.image = blurredImage;
    [sourceView addSubview:blurredImageView];
    CGPoint destinationCenter = destinationView.center;
    destinationView.center = CGPointMake(destinationCenter.x, destinationCenter.y+destinationView.frame.size.height);
    [sourceView addSubview:destinationView];
    destinationView.center = destinationCenter;
    blurredImageView.frame = sourceView.frame;
    
    // Animating
    blurredImageView.alpha = 0.0;
    
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        blurredImageView.alpha = 1.0;
    }
                     completion:^(BOOL finished){
                         [blurredImageView removeFromSuperview];
                         [destinationView removeFromSuperview];
                         [destinationView insertSubview:blurredImageView atIndex:0];
                         completion(blurredImageView, finished);
                     }];
    
}


+ (UIImage *)screenshotsOfView:(UIView *)view {
    // create image of a view
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, scale);
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

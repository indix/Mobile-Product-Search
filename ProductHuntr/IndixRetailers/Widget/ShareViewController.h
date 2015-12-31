//
//  ShareViewController.h
//  Search in IXplore
//
//  Created by Nalin Chhajer on 28/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "IXProduct.h"
#import <AFNetworking/AFNetworking.h>

@protocol ShareViewControllerDelegate;
@interface ShareViewController : UIViewController

@property (nonatomic, strong) IXProduct *product;
@property (nonatomic, assign) BOOL showBack;
@property (nonatomic, assign) id<ShareViewControllerDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@end

@protocol ShareViewControllerDelegate <NSObject>

- (void)close;
- (void)openUrl:(NSURL *)url;
@end
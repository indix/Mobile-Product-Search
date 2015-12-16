//
//  IXRSearchDisplayViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 14/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "IXMSearchType.h"

@interface IXRSearchDisplayViewController : UIViewController

@property (nonatomic, strong) UIImageView *blurredImageView;

@property (nonatomic, assign) BOOL isFromHomeViewController;

@property (nonatomic, assign) CGRect homeSearchRect;

@end




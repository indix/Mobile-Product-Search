//
//  IXRSearchBarHolderView.h
//  IndiXetail
//
//  Created by Nalin Chhajer on 20/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IXRSearchBarHolderViewDelegate;

@interface IXRSearchBarHolderView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, assign) id<IXRSearchBarHolderViewDelegate> delegate;

@property (nonatomic, strong) NSString *searchFieldText;

@end

@protocol IXRSearchBarHolderViewDelegate <NSObject>

@required
- (void)showSearchViewController;
- (void)showScannerViewController;


@end


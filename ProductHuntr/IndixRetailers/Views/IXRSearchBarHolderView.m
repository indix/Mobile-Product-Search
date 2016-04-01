//
//  IXRSearchBarHolderView.m
//  IndiXetail
//
//  Created by Nalin Chhajer on 20/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import "IXRSearchBarHolderView.h"
#import "UIImageEffects.h"

@interface IXRSearchBarHolderView ()

@property (nonatomic, strong) UITextField * searchField;

@end

@implementation IXRSearchBarHolderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIImageView * backgroundview = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundview];
    self.backgroundView = backgroundview;
    // Set up searchbar
    
    int padding = 10.0;
    int searchbarheight = 44;
    int topSpacing = self.bounds.size.height/2 - 22;
    UIView *searchBar = [[UIView alloc] initWithFrame:CGRectMake(padding, topSpacing, self.frame.size.width - (padding * 2), searchbarheight)];
    searchBar.backgroundColor = [UIColor whiteColor];
    [searchBar.layer setCornerRadius:5.0f];
    [searchBar setAccessibilityLabel:@"searchBar"];
    [searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    searchBar.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    searchBar.layer.borderWidth = 1.0f;
    UITextField *searchField = [[UITextField alloc] initWithFrame:searchBar.bounds];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.delegate = self;
    [searchField addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchViewController)]];
    [searchField setAccessibilityLabel:@"searchField"];
    [searchField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    UIButton *searchLeftImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, searchbarheight)];
    [searchLeftImageView setAccessibilityLabel:@"searchLeftMagnifyingGlass"];
    [searchLeftImageView setImage:[UIImage imageNamed:@"search_magnifying_glass_icon.png"] forState:UIControlStateNormal] ;
    [searchLeftImageView setImageEdgeInsets:UIEdgeInsetsMake(12, 7, 12, 7)];
    [searchLeftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchViewController)]];
    searchField.leftView = searchLeftImageView;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    [searchLeftImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    UIButton *searchRightImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, searchbarheight)];
    [searchRightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showScannerViewController)]];
    [searchRightImageView setImage:[UIImage imageNamed:@"search_bar_code.png"] forState:UIControlStateNormal];
    [searchLeftImageView setAccessibilityLabel:@"searchRightBarCode"];
    [searchRightImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    
    searchField.rightView = searchRightImageView;
    searchField.placeholder = @"Search All Products";
    [searchBar addSubview:searchField];
    
    [self addSubview:searchBar];
    
    self.searchField = searchField;
    self.searchBar = searchBar;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self showSearchViewController];
}

- (void)showSearchViewController {
    [self.delegate showSearchViewController];
}

- (void)showScannerViewController {
    [self.delegate showScannerViewController];
}

- (NSString *)searchFieldText {
    return self.searchField.text;
}

- (void)setSearchFieldText:(NSString *)searchFieldText {
    self.searchField.text = searchFieldText;
}

@end

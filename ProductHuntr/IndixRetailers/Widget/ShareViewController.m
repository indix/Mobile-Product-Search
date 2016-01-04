//
//  ShareViewController.m
//  Search in IXplore
//
//  Created by Nalin Chhajer on 28/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "ShareViewController.h"

#import "IXMSavedProduct.h"
#import "IXRetailerHelper.h"
#import <UIImageView+AFNetworking.h>
#import "IXRetailerHelperConfig.h"
#import "IXMDatabaseManager.h"

@interface ShareViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (weak, nonatomic) IBOutlet UIButton *addRemoveFavbutton;
@property (weak, nonatomic) IBOutlet UILabel *category1Label;
@property (weak, nonatomic) IBOutlet UILabel *category2Label;
@property (weak, nonatomic) IBOutlet UILabel *category3Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *category1Widthconstraint;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, assign) BOOL isRefreshingFavoritesDetails;

@property (readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IXMDatabaseManager *databaseManager;
@property (nonatomic, strong) IXMSavedProduct *savedProductDetails;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
//    NSExtensionItem *item = self.extensionContext.inputItems[0];
//    NSItemProvider *itemProvider = item.attachments[0];
//    
//    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
//    }
    return YES;
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting up Local data store
    
    self.databaseManager = [IXMDatabaseManager sharedManager];
    self.managedObjectContext = [self.databaseManager createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    
    self.titleImageView.image = [UIImage imageNamed:[[IXRetailerHelperConfig instance] widgetAppLogoImage]];
    
    self.view.backgroundColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:0.8];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_popupView.bounds];
    _popupView.layer.cornerRadius = 10.0f;
    _popupView.layer.masksToBounds = NO;
    _popupView.layer.shadowColor = [UIColor blackColor].CGColor;
    _popupView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _popupView.layer.shadowOpacity = 0.1f;
    _popupView.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *headershadowPath = [UIBezierPath bezierPathWithRect:self.headerView.bounds];
    _headerView.layer.masksToBounds = NO;
    _headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _headerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _headerView.layer.shadowOpacity = 0.5f;
    _headerView.layer.shadowPath = headershadowPath.CGPath;
    
    if (!self.showBack) {
        self.backButton.hidden = YES;
    }
    
    [self refreshInView:self.popupView];
    [self refreshFavoritesOption];
    
}

- (void)refreshInView:(UIView *)view {
    // DebugLog(@" product result.. %@",result);
    self.titleLabel.text = self.product.name;
    NSString *price = self.product.priceRangeLabel;
    self.priceLabel.text = price;
    
    NSNumber *avaialbleStore = [NSNumber numberWithInt:[self.product.noOfStores intValue]];
    if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:0]]) {
        self.availabilityLabel.text = @"";
    } else if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.availabilityLabel.text = [NSString stringWithFormat:@"Available in %@ Store",avaialbleStore];
    }
    else {
        self.availabilityLabel.text = [NSString stringWithFormat:@"Available in %@ Stores",avaialbleStore];
    }
    
    self.moreButton.tintColor = [UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0];
    
    [self.imageView  setImageWithURL:[NSURL URLWithString:self.product.imageURL] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
    [self.imageView.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
    [self.imageView.layer setBorderWidth: 1.0];
    
    [self.addRemoveFavbutton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteButtonTapped:)]];
    
    [self refreshAddToFavorite];
    
    float frameWidth = view.frame.size.width;
    float constraintwidth = frameWidth/3 - 10;
    self.category1Widthconstraint.constant = constraintwidth;
    [self.view layoutIfNeeded];
    
    [self setCategoryBorder:self.category1Label];
    [self setCategoryBorder:self.category2Label];
    [self setCategoryBorder:self.category3Label];
    self.category1Label.hidden = YES;
    self.category2Label.hidden = YES;
    self.category3Label.hidden = YES;
    
    NSArray *categoryArray = [self.product allCategoryName];
    
    NSInteger count = categoryArray.count;
    if (count - 1 >= 0) {
        self.category1Label.text = [categoryArray objectAtIndex:count - 1];
        self.category1Label.hidden = NO;
    }
    
    if (count - 2 >= 0) {
        self.category2Label.text = [categoryArray objectAtIndex:count - 2];
        self.category2Label.hidden = NO;
    }
    
    if (count - 3 >= 0) {
        self.category3Label.text = [categoryArray objectAtIndex:count - 3];
        self.category3Label.hidden = NO;
    }
}

- (void)setCategoryBorder:(UILabel *)label {
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.layer.cornerRadius = 5.0;
    [label.layer setBorderColor: [[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:0.2] CGColor]];
    [label.layer setBorderWidth: 1.0];
}

- (IBAction)moreClickListener:(id)sender {
    NSString *shareStringIdentifier = [[IXRetailerHelperConfig instance] shareWidgetIdentifier];
    ;
    [self.delegate openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",shareStringIdentifier, @"://product_detail?mpid=", self.product.mpid]]];
}

- (IBAction)doneTapped:(id)sender {
    [self.delegate close];
    
}

- (IBAction)backButtontapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)refreshFavoritesOption {
    if (self.product) {
        self.isRefreshingFavoritesDetails = YES;
        [self refreshAddToFavorite];
        IXMSavedProduct* prod = [self.self.databaseManager requestCheckIfAddedToFavorites:self.product forManagedContext:self.managedObjectContext];
        if (prod) {
            self.savedProductDetails = prod;
        }
        self.isRefreshingFavoritesDetails = NO;
    }
    [self refreshAddToFavorite];
}



- (void)refreshAddToFavorite {
    [self.addRemoveFavbutton setEnabled:!self.isRefreshingFavoritesDetails];
    if (self.isRefreshingFavoritesDetails) {
        
    }
    else {
        if ([self isSavedToFavorites]) {
            [self.addRemoveFavbutton setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        }
        else {
            [self.addRemoveFavbutton setTitle:@"Add to favorites" forState:UIControlStateNormal];
        }
    }
    
    
    
}

- (BOOL)isSavedToFavorites {
    return self.savedProductDetails != nil;
}

- (void)favoriteButtonTapped:(id)sender {
    [self changeFavoritesState];
}

- (void)changeFavoritesState {
    
    if (self.isRefreshingFavoritesDetails) {
        NSLog(@"ERROR!! Calling change in favorites while the old not completed yet");
        return;
    }
    
    self.isRefreshingFavoritesDetails = YES;
    [self refreshAddToFavorite];
    if ([self isSavedToFavorites]) {
        [self.databaseManager requestRemoveFromFavorites:self.savedProductDetails forManagedContext:self.managedObjectContext success:^{
            self.isRefreshingFavoritesDetails = NO;
            self.savedProductDetails = nil;
            [self refreshAddToFavorite];
        } failure:^(NSError *error) {
            self.isRefreshingFavoritesDetails = NO;
            [self refreshAddToFavorite];
        }];
    }
    else {
        [self.databaseManager requestAddToFavorites:self.product forManagedContext:self.managedObjectContext success:^(IXMSavedProduct *saved_product) {
            self.isRefreshingFavoritesDetails = NO;
            self.savedProductDetails = saved_product;
            [self refreshAddToFavorite];
        } failure:^(NSError *error) {
            self.isRefreshingFavoritesDetails = NO;
            [self refreshAddToFavorite];
        }];
    }
    
}




@end

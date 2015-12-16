//
//  IXRCatalogViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCatalogViewController.h"
#import "IXRCatalogParentImplViewController.h"
#import "IXRetailerHelper.h"

@interface IXRCatalogViewController () {
    IXRCatalogParentImplViewController<IXRCatalogParentImplViewControllerDelegate> *selectedSegmentViewController;
    UIView *segmentContentView;
    NSInteger selectedChildAtIndex;
}

@property (nonatomic, strong) NSArray *childTitles;
@property (nonatomic, strong) NSMutableArray *segmentedChildViewControllers;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation IXRCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    // Do any additional setup after loading the view.
    self.childTitles = @[@"Product Details", @"Price Across Stores"];
    self.isFetchingProductDetails = NO;
    self.totalPriceOfferCount = 0;
    self.pricePageNumber = 1;
    
    // Making all object in copy array as null
    self.segmentedChildViewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i < self.childTitles.count; i++) {
        [self.segmentedChildViewControllers addObject:[NSNull null]];
    }
    selectedChildAtIndex = 0;
    segmentContentView = [self containerView];
    
    if (self.product) {
        self.activityIndicator.hidden = YES;
        [self setUpSegmentControl];
        
        // fetch description and keep it inform to child view controllers;
        [self performDetailProductDetailFetch];
    }
    else {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        
        [self performFetchProductUsingMPId];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSegmentControl {
    // segment
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:self.childTitles];
    [segmentedControl sizeToFit];
    segmentedControl.selectedSegmentIndex = selectedChildAtIndex;
    segmentedControl.tintColor = [UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0];    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    // First view controller
    IXRCatalogParentImplViewController<IXRCatalogParentImplViewControllerDelegate> *vc = [self viewControllerForSegmentIndex:segmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = segmentContentView.bounds;
    [segmentContentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    selectedSegmentViewController = vc;
    
    self.segmentedControl = segmentedControl;
}



- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    [self setSegmentTransitionToIndex:sender.selectedSegmentIndex];
    
}

- (void)setSegmentTransitionToIndex:(NSInteger)index {
    IXRCatalogParentImplViewController<IXRCatalogParentImplViewControllerDelegate> *vc = [self viewControllerForSegmentIndex:index];
    [self addChildViewController:vc];
    [self transitionFromViewController:selectedSegmentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [selectedSegmentViewController.view removeFromSuperview];
        vc.view.frame = segmentContentView.bounds;
        [segmentContentView addSubview:vc.view];
        
    } completion:^(BOOL finished) {
        
        [vc didMoveToParentViewController:self];
        [selectedSegmentViewController removeFromParentViewController];
        selectedSegmentViewController = vc;
        
    }];

}

- (void)switchSegmentToPrice {
    self.segmentedControl.selectedSegmentIndex = 1;
    [self setSegmentTransitionToIndex:1];
}

- (IXRCatalogParentImplViewController<IXRCatalogParentImplViewControllerDelegate> *)viewControllerForSegmentIndex:(NSInteger)index {
    
    IXRCatalogParentImplViewController<IXRCatalogParentImplViewControllerDelegate> *vc;
    
    if (![[self.segmentedChildViewControllers objectAtIndex:index] isEqual:[NSNull null]]) {
        vc = [self.segmentedChildViewControllers objectAtIndex:index];
    }
    else {
        switch (index) {
            case 0:
                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"catalogDescriptionVC"];
                vc.parentVC = self;
                break;
            case 1:
                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"catalogPriceVC"];
                vc.parentVC = self;
                break;
        }
        NSAssert(vc != nil, @"View Controller cannot be null");
        NSAssert([vc conformsToProtocol:@protocol(IXRCatalogParentImplViewControllerDelegate)], @"View controller doesnot conform to protocol IXRCatalogParentImplViewControllerDelegate");
        [self.segmentedChildViewControllers setObject:vc atIndexedSubscript:index];

    }
    NSAssert(vc != nil, @"View Controller cannot be null");
    return vc;
}

- (void)performFetchProductUsingMPId {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [IXRetailerHelper requestProductCatalogForProductUsingMPid:self.productMPid withManager:nil success:^(AFHTTPRequestOperation *operation,IXProduct *product, IXMProductDetail *productDesc, NSArray *productprices, NSInteger offerCount) {
        if (product) {
            self.product = product;
            self.productDescription = productDesc;
            self.priceAcrossStores = [[NSMutableArray alloc] initWithArray:productprices];
            self.totalPriceOfferCount = offerCount;
            
            [self setUpSegmentControl];
            self.activityIndicator.hidden = YES;
        }
        else {
            self.activityIndicator.hidden = YES;
            [[[UIAlertView alloc] initWithTitle:@"Could not find product" message:@"Sorry, Could not found this product." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.activityIndicator.hidden = YES;
        [[[UIAlertView alloc] initWithTitle:@"Could not find product" message:@"Sorry, Could not found this product." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }];
}

- (void)performDetailProductDetailFetch {
    self.isFetchingProductDetails = YES;
    [self informStartingProductDetailfetch];
    
    [IXRetailerHelper requestProductCatalogForProduct:self.product withManager:nil success:^(AFHTTPRequestOperation *operation, IXMProductDetail *productDesc, NSArray *productprices, NSInteger offerCount) {
        self.productDescription = productDesc;
        self.priceAcrossStores = [[NSMutableArray alloc] initWithArray:productprices];
        self.isFetchingProductDetails = NO;
        self.totalPriceOfferCount = offerCount;
        [self informProductDetailfetchFinished:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isFetchingProductDetails = NO;
        [self informProductDetailfetchFinished:NO];
        
    }];
}

- (void)informStartingProductDetailfetch {
    [selectedSegmentViewController startingProductDetailfetch];
}

- (void)informProductDetailfetchFinished:(BOOL)isSucess {
    [selectedSegmentViewController productDetailfetchFinished:isSucess];
}

- (void)informStartingFavouritesChange {
    [selectedSegmentViewController startingFavoritesChange];
}

- (void)informFavouritesChangeFinished:(BOOL)isSuccess {
    [selectedSegmentViewController favoritesChangeFinished:isSuccess];
}

- (void)addPricesFromArray:(NSArray *)productprices forPage:(NSInteger)page {
    [self.priceAcrossStores addObjectsFromArray:productprices];
    self.pricePageNumber = page;
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

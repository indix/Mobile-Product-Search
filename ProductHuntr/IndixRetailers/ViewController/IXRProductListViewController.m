//
//  IXRProductListViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 18/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRProductListViewController.h"
#import "IXProductResultsCell.h"
#import "IXProduct.h"
#import <UIImageView+AFNetworking.h>
#import "IXRetailerHelper.h"
#import "IXRUtils.h"
#import "IXRCatalogViewController.h"
#import "IXRProductFilterViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageEffects.h"
#import "IXRetailerHelperConfig.h"
#import "IXMDatabaseManager.h"


@interface IXRProductListViewController () <UIActionSheetDelegate, IXRProductFilterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *sortProductButton;
@property (weak, nonatomic) IBOutlet UIButton *filterOption;
@property (weak, nonatomic) IBOutlet UIView *filterOptionDivider;

@property (weak, nonatomic) IBOutlet UIButton *typeOfLayoutButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noResultView;
@property (weak, nonatomic) IBOutlet UIView *filteredResultView;
@property (weak, nonatomic) IBOutlet UIView *titleBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *titleBarBackgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *titleBarholder;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;


@property (nonatomic, strong) UIActivityIndicatorView *loadingMoreView;
@property (nonatomic, strong) UIActivityIndicatorView *gridloadingMoreView;
@property (nonatomic, strong) UIBarButtonItem *feedbackBarButton;

@property (nonatomic, strong) NSMutableArray *productsListArray;
@property (nonatomic, assign) NSInteger totalProduct;
@property (nonatomic, strong) IXMFilterObjects *filterObjects;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL isGridLayout;
@property (nonatomic, assign) BOOL isLoadingMoreProducts;
@property (nonatomic, strong) AFHTTPRequestOperationManager *productListManager;

@property (nonatomic, assign) NSInteger successValue; // Used by save search to make sure saved search are not saved again and again

@property (nonatomic, strong) IXMSelectedFilters *selectedFilters;
@property (nonatomic, assign) BOOL doFilterResult;

@property (nonatomic, assign) NSInteger selectedFilterTabIndex;
@property (nonatomic, strong) IXMDisplayCategoryFilter *selectedCategoryDisplayObject;

@property (readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IXMDatabaseManager *databaseManager;


@property (nonatomic, strong) IXProduct *lastProductForLongPress;
@property (nonatomic, assign) NSInteger lastPositionForLongPress;
@property (nonatomic, strong) IXMSavedProduct *lastSavedProductForLongPress;

@end

@implementation IXRProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTitleView];
    [self setUpOptionMenu];
    [self setUpListTypeView];
    [self setUpGridTypeView];
    
    
    
    // Initialize
    self.productListManager = [IXRetailerHelper getRequestOperationManager];
    self.productsListArray = [[NSMutableArray alloc] init];
    self.isGridLayout = NO;
    [self refreshTypeOfLayout];
    self.totalProduct = 0;
    self.pageNumber = 1;
    self.isLoadingMoreProducts = NO;
    self.successValue = 0;
    self.noResultView.hidden = YES;
    self.filteredResultView.hidden = YES;
    self.doFilterResult = NO;
    self.selectedFilterTabIndex = 0;
    self.sortType = [IXMSortType getSorttypeForKey:kIXRSortTypeRelevance];
    
    [self refreshSortProductButton];
    
    // Start
    [self refreshTitle];
    [self performSearchOperation];
    
    self.databaseManager = [IXMDatabaseManager sharedManager];
    self.managedObjectContext = [self.databaseManager createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (IBAction)chooseGridListTypeSelected:(id)sender {
    self.isGridLayout = !self.isGridLayout;
    [self refreshTypeOfLayoutButton:YES];
}

- (IBAction)sortProductButtonSelected:(id)sender {
    
    NSArray *allSort = [IXMSortType getAllSortType];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (IXMSortType *object in allSort) {
        [actionSheet addButtonWithTitle:[self patchActionSheetTitle:object]];
    }
    
    [actionSheet setTag:100];
    
    [actionSheet showInView:self.view];
    
}

- (IBAction)filterProductButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"filterVCSegue" sender:self];
}

- (IBAction)backButoonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)patchActionSheetTitle:(IXMSortType *)type {
    if ([type.key isEqualToString:self.sortType.key]) {
        return [@"\u2022 " stringByAppendingString:type.title];
    }
    return type.title;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100) {
        NSArray *sortArray = [IXMSortType getAllSortType];
        NSInteger sortIndex = buttonIndex - 1;
        if (sortIndex >= 0  && sortIndex < sortArray.count) {
            [self resetSortType:[sortArray objectAtIndex:sortIndex]];
        }
    }
    else if (actionSheet.tag == 101) {
        
        if (buttonIndex == 0) {
            if (self.lastSavedProductForLongPress) {
                [self.databaseManager requestRemoveFromFavorites:self.lastSavedProductForLongPress forManagedContext:self.managedObjectContext success:^{
                    self.lastSavedProductForLongPress = nil;
                    self.lastProductForLongPress = nil;
                    self.lastPositionForLongPress = 0;
                } failure:^(NSError *error) {
                    self.lastSavedProductForLongPress = nil;
                    self.lastProductForLongPress = nil;
                    self.lastPositionForLongPress = 0;
                }];
            }
            else if (self.lastProductForLongPress) {
                [self.databaseManager requestAddToFavorites:self.lastProductForLongPress forManagedContext:self.managedObjectContext success:^(IXMSavedProduct *saved_product) {
                    self.lastSavedProductForLongPress = nil;
                    self.lastProductForLongPress = nil;
                    self.lastPositionForLongPress = 0;
                } failure:^(NSError *error) {
                    self.lastSavedProductForLongPress = nil;
                    self.lastProductForLongPress = nil;
                    self.lastPositionForLongPress = 0;
                }];
                
            }
        }
        
        
    }

}


- (void)resetSortType:(IXMSortType *)sortType {
    IXMSortType *oldSort = self.sortType;
    IXMSortType *newSort = sortType;
    self.sortType = sortType;
    [self refreshSortProductButton];
    [self performSortOperation];
    if (![oldSort.key isEqualToString:newSort.key]) {
        
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showCatalogVC"]) {
        IXRCatalogViewController *controller = segue.destinationViewController;
        NSDictionary *dict = sender;
        controller.product = [dict objectForKey:@"product"];
    }
    else if ([segue.identifier isEqualToString:@"filterVCSegue"]) {
        IXRProductFilterViewController *productFilter = (IXRProductFilterViewController *)[segue.destinationViewController topViewController];
        productFilter.filterObjects = self.filterObjects;
        productFilter.delegate = self;
        productFilter.selectedFilters = self.selectedFilters;
        productFilter.searchQuery = self.searchQuery;
        productFilter.selectedFilterTabIndex = self.selectedFilterTabIndex;
        productFilter.categoryDisplay= self.selectedCategoryDisplayObject;
    }else if ([segue.identifier isEqualToString:@"showCatagorySelectVC"]) {
        IXRProductFilterViewController *productFilter = (IXRProductFilterViewController *)[segue.destinationViewController topViewController];
        productFilter.filterObjects = self.filterObjects;
        productFilter.delegate = self;
        productFilter.selectedFilters = self.selectedFilters;
        productFilter.searchQuery = self.searchQuery;
        productFilter.selectedFilterTabIndex = self.selectedFilterTabIndex;
        productFilter.categoryDisplay= self.selectedCategoryDisplayObject;
    }
    
}

- (void)didCancelFilter {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doFiltersForSelectedFilter:(IXMSelectedFilters *)filters {
    self.selectedFilters = filters;
    
    if ([filters containsFilter]) {
        self.doFilterResult = YES;
        self.filteredResultView.hidden = NO;
    }
    else {
        self.doFilterResult = NO;
        self.filteredResultView.hidden = YES;
    }
    [self performFilteredOperation];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didAskForClearFilter {
    self.doFilterResult = NO;
    self.filteredResultView.hidden = YES;
    [self performFilteredOperation];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didSelectedSegmentAtIndex:(NSInteger)index {
    self.selectedFilterTabIndex = index;
}

- (void)didDownloadAndModifyCategoryDisplay:(IXMDisplayCategoryFilter *)filter {
    self.selectedCategoryDisplayObject = filter;
}

- (void)removeFilteredResultTapped:(id)sender {
    self.doFilterResult = NO;
    self.filteredResultView.hidden = YES;
    [self performFilteredOperation];
}

- (IBAction)feedbackButtonPressed:(id)sender {
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.doFilterResult) {
        return self.filteredResultView.frame.size.height;
    }
    else {
        return 1.0;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productsListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProductCellIdentifier = @"ProductResultsCell";
    
    IXProductResultsCell *productResultCell =  [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
    NSArray *nibArray;
    if (productResultCell == nil) {
        nibArray = [[NSBundle mainBundle] loadNibNamed:@"IXProductResultsTableViewCell" owner:self options:nil];
        productResultCell = [nibArray objectAtIndex:0];
    }
    IXProduct *result;
    if ([self.productsListArray count]>0) {
        result = [self.productsListArray objectAtIndex:[indexPath row]];
    }
    // DebugLog(@" product result.. %@",result);
    productResultCell.productName.text = result.name;
    NSString *price = result.priceRangeLabel;
    productResultCell.productPrice.text = price;
    
    NSNumber *avaialbleStore = [NSNumber numberWithInt:[result.noOfStores intValue]];
    if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:0]]) {
        productResultCell.availableStores.text = @"";
    } else if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:1]]) {
        productResultCell.availableStores.text = [NSString stringWithFormat:@"Available in %@ Store",avaialbleStore];
    }
    else {
        productResultCell.availableStores.text = [NSString stringWithFormat:@"Available in %@ Stores",avaialbleStore];
    }
    
    [productResultCell.productImage  setImageWithURL:[NSURL URLWithString:result.imageURL] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
    [productResultCell.productImage.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
    [productResultCell.productImage.layer setBorderWidth: 1.0];
    
    
    [productResultCell setTag:1000 + indexPath.row];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnProductList:)];
    [productResultCell addGestureRecognizer:lpgr];
    return productResultCell;
}


// Set the background color for Cell!
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [self.productsListArray count]-1) {
        [self lazyLoadProducts];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IXProduct *result = [self.productsListArray objectAtIndex:[indexPath row]];
    NSDictionary *dict = @{@"product":result, @"position":[NSNumber numberWithInteger:indexPath.row]};
    [self performSegueWithIdentifier:@"showCatalogVC" sender:dict];
}


#pragma mark - Lazy load products
- (void) lazyLoadProducts{
    if (!self.isLoadingMoreProducts && [IXRetailerHelper isPaginationPossibleForPage:self.pageNumber+1 andTotalCount:self.totalProduct]) {
        [self performLoadMoreOperation];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productsListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    IXProduct *result;
    if ([self.productsListArray count]>0) {
        result = [self.productsListArray objectAtIndex:[indexPath row]];
    }
    
    UIImageView *productImageView = (UIImageView *)[cell viewWithTag:100];
    [productImageView setImageWithURL:[NSURL URLWithString:result.imageURL] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
    UILabel *label = (UILabel*)[cell viewWithTag:101];
    label.text = result.name;
    
    
    UILabel *priceLabel = (UILabel*)[cell viewWithTag:102];
    
    NSString *price = result.priceRangeLabel;
    priceLabel.text = price;
    [productImageView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
//    [productImageView.layer setBorderWidth: 1.0];
//    productImageView.layer.cornerRadius = 5.0f;
    
    if ([indexPath row] == [self.productsListArray count]-1) {
        //lazy load..
        [self lazyLoadProducts];
    }
    
    [cell setTag:1000 + indexPath.row];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnProductGrid:)];
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    IXProduct *result = [self.productsListArray objectAtIndex:[indexPath row]];
    NSDictionary *dict = @{@"product":result, @"position":[NSNumber numberWithInteger:indexPath.row]};
    [self performSegueWithIdentifier:@"showCatalogVC" sender:dict];
}

#pragma mark - UICollectionViewDelegate
//indicate the spacing on either side of a single line of items.
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.doFilterResult) {
        return UIEdgeInsetsMake(self.filteredResultView.frame.size.height + 10.0,10.0,10.0,10.0);
    }
    else {
        return UIEdgeInsetsMake(10.0,10.0,10.0,10.0);
    }
    
    
}

//Minimum spacing between items in the same row.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
    
}

//For a vertically scrolling grid, this value represents the minimum spacing between successive rows.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)[ footerview viewWithTag:11];
        activityIndicatorView.hidesWhenStopped = YES;
        self.gridloadingMoreView = activityIndicatorView;
        
        reusableview = footerview;
    }
    
    
    return reusableview;
}


#pragma mark - bottom bar

- (void)refreshTypeOfLayoutButton:(BOOL)refresh {
    
    if (self.isGridLayout) {
        [self.typeOfLayoutButton setImage:[[UIImage imageNamed:@"icon_type_list.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        if (refresh) {
            [self.collectionView reloadData];
        }
    }
    else {
        [self.typeOfLayoutButton setImage:[[UIImage imageNamed:@"icon_type_grid.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        if (refresh) {
            [self.tableView reloadData];
        }
    }
    
    
}

- (void)refreshTypeOfLayout {
    [self refreshTypeOfLayoutButton:NO];
}

- (void)refreshSortProductButton {
    
    [self.sortProductButton setTitle:self.sortType.title forState:UIControlStateNormal];
}

#pragma mark - utilis

- (void)handleLongPressOnProductList:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSInteger index = gesture.view.tag - 1000;
        IXProduct *result = [self.productsListArray objectAtIndex:index];
        
        IXMSavedProduct *saved_product = [self.databaseManager requestCheckIfAddedToFavorites:result forManagedContext:self.managedObjectContext];
        
        if (saved_product) {
            self.lastSavedProductForLongPress = saved_product;
            self.lastProductForLongPress = result;
            self.lastPositionForLongPress = index;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove from favorites", nil];
            
            [actionSheet setTag:101];
            
            [actionSheet showInView:self.view];
        }
        else {
            self.lastSavedProductForLongPress = nil;
            self.lastProductForLongPress = result;
            self.lastPositionForLongPress = index;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to favorites", nil];
            
            [actionSheet setTag:101];
            
            [actionSheet showInView:self.view];
        }
        
    }
    
    
    
}

- (void)handleLongPressOnProductGrid:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSInteger index = gesture.view.tag - 1000;
        IXProduct *result = [self.productsListArray objectAtIndex:index];
        
        IXMSavedProduct *saved_product = [self.databaseManager requestCheckIfAddedToFavorites:result forManagedContext:self.managedObjectContext];
        
        if (saved_product) {
            self.lastSavedProductForLongPress = saved_product;
            self.lastProductForLongPress = result;
            self.lastPositionForLongPress = index;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove from favorites", nil];
            
            [actionSheet setTag:101];
            
            [actionSheet showInView:self.view];
        }
        else {
            self.lastSavedProductForLongPress = nil;
            self.lastProductForLongPress = result;
            self.lastPositionForLongPress = index;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to favorites", nil];
            
            [actionSheet setTag:101];
            
            [actionSheet showInView:self.view];
        }
    }
    
    
    
}

- (void)setUpOptionMenu {
    UIColor *tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    
    [self.filterOption setImage:[[UIImage imageNamed:@"icon_type_filter_option"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.filterOption setTintColor:tintColor];
    
    
    [self.sortProductButton setImage:[[UIImage imageNamed:@"icon_type_sort"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.sortProductButton setTintColor:tintColor];
    [self.sortProductButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    [self.typeOfLayoutButton  setTintColor:tintColor];
    
    self.titleLabel.textColor = tintColor;
    self.subtitleLabel.textColor = tintColor;
    
    [self.backButton setImage:[[UIImage imageNamed:@"backicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.backButton.tintColor = tintColor;
    
    if ([self.searchtype.key isEqualToString:kIXRSearchTypeAll]) {
        [self.sortProductButton setHidden:NO];
        [self.filterOption setHidden:NO];
        [self.filterOptionDivider setHidden:NO];
        [self.filterOption setEnabled:NO];
    }
    else {
        [self.sortProductButton setHidden:YES];
        [self.filterOption setHidden:YES];
        [self.filterOptionDivider setHidden:YES];
    }
    
    [self.filteredResultView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFilteredResultTapped:)] ];
}


- (void)setUpListTypeView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
    self.loadingMoreView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingMoreView setFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableFooterView = self.loadingMoreView;
}

- (void)setUpGridTypeView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.view.frame;
    CGFloat width = frame.size.width - 30;
    CGFloat itemSize = floor(width/2) ;
    
    
    self.collectionViewFlowLayout.itemSize = CGSizeMake(itemSize, 220);
}

- (void)setUpTitleView {
    
    if (!self.titleBarImage) {
        self.titleBarImage = [UIImage imageNamed:[[IXRetailerHelperConfig instance] listTitleBlurredBackgroundImage]];
    }
    
    UIImage *blurredBackgroundImage = [UIImageEffects imageByApplyingBlurToImage:self.titleBarImage withRadius:120.0 tintColor:[UIColor colorWithRed:160.0/255.0 green:45.0/255.0 blue:113.0/255.0 alpha:0.1] saturationDeltaFactor:1.8 maskImage:nil];
    
    self.titleBarBackgroundImageView.image = blurredBackgroundImage;
//    self.titleBarBackgroundImageView.backgroundColor = [[IXRTheme instance] buttonTintColor];
    
    self.subtitleLabel.text = @"";
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_titleBarholder.bounds];
    _titleBarholder.layer.masksToBounds = NO;
    _titleBarholder.layer.shadowColor = [UIColor blackColor].CGColor;
    _titleBarholder.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _titleBarholder.layer.shadowOpacity = 0.5f;
    _titleBarholder.layer.shadowPath = shadowPath.CGPath;
}

- (void)refreshTitle {
    NSString *searchQuery;
    searchQuery = self.searchQuery;
    self.title = @"";
    
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:[searchQuery capitalizedString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    
    
    
}

- (void)refreshSubTitleText {
    self.subtitleLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ products", [IXRUtils shortStringForInteger:self.totalProduct]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
}

- (void)performSearchOperation {
    
    [self.productsListArray removeAllObjects];
    self.noResultView.hidden = YES;
    // start a locading indicator
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    
    [self requestSearchWithPageNumber:1 success:^ {
        self.pageNumber = 1;
        self.loadingIndicator.hidden = YES;
        [self.tableView reloadData];
        [self refreshSubTitleText];
        [self.collectionView reloadData];
        if (self.totalProduct == 0) {
            self.noResultView.hidden = NO;
            [self.feedbackBarButton setEnabled:NO];
        }
        else {
            self.noResultView.hidden = YES;
            [self.feedbackBarButton setEnabled:YES];
        }
    } failure:^ {
        
        self.loadingIndicator.hidden = YES;
        [self.feedbackBarButton setEnabled:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry!! We were not able to connect, check your network connection and try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

- (void)performFilteredOperation {
    [self performRefreshFromScratch];
}

- (void)performSortOperation {
    
    [self performRefreshFromScratch];
}

- (void)performRefreshFromScratch {
    [self.productsListArray removeAllObjects];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    self.noResultView.hidden = YES;
    // start a locading indicator
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    
    [self requestSearchWithPageNumber:1 success:^ {
        self.pageNumber = 1;
        self.loadingIndicator.hidden = YES;
        [self.tableView reloadData];
        [self refreshSubTitleText];
        [self.collectionView reloadData];
        if (self.totalProduct == 0) {
            self.noResultView.hidden = NO;
            [self.feedbackBarButton setEnabled:NO];
        }
        else {
            self.noResultView.hidden = YES;
            [self.feedbackBarButton setEnabled:YES];
        }
    } failure:^ {
        
        self.loadingIndicator.hidden = YES;
        [self.feedbackBarButton setEnabled:NO];
        
    }];
}

- (void)performLoadMoreOperation {
    NSLog(@"loading product page %ld", (long)self.pageNumber + 1);
    self.isLoadingMoreProducts = YES;
    self.gridloadingMoreView.hidden = NO;
    self.loadingMoreView.hidden = NO;
    [self.loadingMoreView startAnimating];
    
    [self requestSearchWithPageNumber:self.pageNumber + 1 success:^ {
        self.pageNumber = self.pageNumber + 1;
        self.loadingMoreView.hidden = YES;
        self.gridloadingMoreView.hidden = YES;
        [self.tableView reloadData];
        self.isLoadingMoreProducts = NO;
        [self.collectionView reloadData];
        
    } failure:^ {
        
        self.loadingMoreView.hidden = YES;
        self.gridloadingMoreView.hidden = YES;
        self.isLoadingMoreProducts = NO;
        
        
    }];
}

- (void)requestSearchWithPageNumber:(NSInteger)page success:(void (^)(void))success failure:(void (^)(void))failure{
    
    if ([self.searchtype.key isEqualToString:kIXRSearchTypeSKU]) {
        [self cancelProductListOperation];
        [IXRetailerHelper requestSKUSearchForQuery:self.searchQuery page:[NSString stringWithFormat:@"%lu", (unsigned long)page] sortBy:self.sortType withManager:self.productListManager success:^(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count) {
            
            [self.productsListArray addObjectsFromArray:productsArray];
            self.totalProduct = count;
            
            if (self.saveSearchOnSuccess && self.successValue == 0) {
                [IXRetailerHelper addRecentSearchItemWithQuery:self.searchQuery SearchType:self.searchtype.key result:^(BOOL success) {
                    
                }];
            }
            self.successValue = self.successValue + 1;
            
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (![operation isCancelled]) {
                failure();
            }
            
        }];
    }
    else if ([self.searchtype.key isEqualToString:kIXRSearchTypeMPN]) {
        [self cancelProductListOperation];
        [IXRetailerHelper requestMPNSearchForQuery:self.searchQuery page:[NSString stringWithFormat:@"%lu", (unsigned long)page] sortBy:self.sortType withManager:self.productListManager success:^(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count) {
            
            [self.productsListArray addObjectsFromArray:productsArray];
            self.totalProduct = count;
            
            if (self.saveSearchOnSuccess && self.successValue == 0) {
                [IXRetailerHelper addRecentSearchItemWithQuery:self.searchQuery SearchType:self.searchtype.key result:^(BOOL success) {
                    
                }];
            }
            self.successValue = self.successValue + 1;
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (![operation isCancelled]) {
                failure();
            }
        }];
    }
    else if ([self.searchtype.key isEqualToString:kIXRSearchTypeUPC]) {
        [self cancelProductListOperation];
        [IXRetailerHelper requestUPCSearchForQuery:self.searchQuery page:[NSString stringWithFormat:@"%lu", (unsigned long)page] sortBy:self.sortType withManager:self.productListManager success:^(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count) {
            
            [self.productsListArray addObjectsFromArray:productsArray];
            self.totalProduct = count;
            
            if (self.saveSearchOnSuccess && self.successValue == 0) {
                [IXRetailerHelper addRecentSearchItemWithQuery:self.searchQuery SearchType:self.searchtype.key result:^(BOOL success) {
                    
                }];
            }
            self.successValue = self.successValue + 1;
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (![operation isCancelled]) {
                failure();
            }
        }];
    }
    else if ([self.searchtype.key isEqualToString:kIXRSearchTypeAll]) {
        [self cancelProductListOperation];
        
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        if (self.doFilterResult) {
            [settings setValue:self.selectedFilters forKey:@"filter"];
        }
        
        
        [IXRetailerHelper requestGeneralSearchForQuery:self.searchQuery page:[NSString stringWithFormat:@"%lu", (unsigned long)page] sortBy:self.sortType settings:settings withManager:self.productListManager success:^(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count, IXMFilterObjects *filter) {
            
            [self.productsListArray addObjectsFromArray:productsArray];
            self.totalProduct = count;
            
            if (self.doFilterResult && [self.filterObjects containsFilter]) {
                
            }
            else {
                self.filterObjects = filter;
                
                if (self.filterObjects && [self.filterObjects containsFilter]) {
                    [self.filterOption setEnabled:YES];
                }
            }
            
            
            
            if (self.saveSearchOnSuccess && self.successValue == 0) {
                [IXRetailerHelper addRecentSearchItemWithQuery:self.searchQuery SearchType:self.searchtype.key result:^(BOOL success) {
                    
                }];
            }
            self.successValue = self.successValue + 1;
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (![operation isCancelled]) {
                failure();
            }
        }];
    }
}

- (void)cancelProductListOperation {
    [self.productListManager.operationQueue  cancelAllOperations];
}



@end

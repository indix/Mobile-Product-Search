//
//  HomeViewController.m
//  ProductHuntr
//
//  Created by Nalin Chhajer on 04/01/16.
//  Copyright © 2016 Indix. All rights reserved.
//

#import "HomeViewController.h"
#import "IndixRetailers.h"
#import "UIImageEffects.h"
#import <UIImageView+AFNetworking.h>

@interface HomeViewController ()<IXRSearchBarHolderViewDelegate, IXScannerViewControllerDelegate, NSFetchedResultsControllerDelegate, IXROpenUrlHandlerDelagate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *retailerAppTitleView;


@property (nonatomic, strong) IXRSearchBarHolderView *searchBarholder;
@property (nonatomic, strong) UIStoryboard *retailerStoryboard;
@property (nonatomic, strong) IXROpenUrlHandler *openUrlHandler;

@property (nonatomic, strong) IXMDatabaseManager *databaseManager;
@property (readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.openUrlHandler = [[IXROpenUrlHandler alloc] init];
    self.openUrlHandler.delegate = self;
    
    self.databaseManager = [IXMDatabaseManager sharedManager];
    self.managedObjectContext = [self.databaseManager createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [self setTableHeaderViewWithSearchBar];
    
    // Addign a shadow on title bar
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_retailerAppTitleView.bounds];
    _retailerAppTitleView.layer.masksToBounds = NO;
    _retailerAppTitleView.layer.shadowColor = [UIColor blackColor].CGColor;
    _retailerAppTitleView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _retailerAppTitleView.layer.shadowOpacity = 0.5f;
    _retailerAppTitleView.layer.shadowPath = shadowPath.CGPath;
    
    self.retailerStoryboard = [IXRViewControllerHelper retailerStoryboard];
    
    
    self.title = @"Product Huntr";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchBarholder.searchFieldText = @""; // To clear field
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
    self.searchBarholder.searchFieldText = barcodeId;
    [self.navigationController popViewControllerAnimated:YES];
    
    // Save in recent searches if it is success.
    IXRProductListViewController *productVC = [IXRViewControllerHelper productListViewController:self.retailerStoryboard];
    IXMSearchType *searchType = [IXMSearchType getSearchtypeForKey:kIXRSearchTypeUPC];
    productVC.searchtype = searchType;
    productVC.searchQuery = barcodeId;
    productVC.saveSearchOnSuccess = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}



#pragma mark - Search bar
- (void)setTableHeaderViewWithSearchBar {
    
    CGRect tableHeaderViewRect = CGRectMake(0, 0, self.view.frame.size.width, 160);
    IXRSearchBarHolderView * tableHeaderView = [[IXRSearchBarHolderView alloc] initWithFrame:tableHeaderViewRect];
    tableHeaderView.delegate = self;
    [self.tableView setTableHeaderView:tableHeaderView];
    
    UIImage* backgroundImage = [UIImage imageNamed:[[IXRetailerHelperConfig instance] homeScreenBlurredBackgroundImage]];
    UIImage *blurredBackgroundImage = [UIImageEffects imageByApplyingBlurToImage:backgroundImage withRadius:25.0 tintColor:[[IXRetailerHelperConfig instance] homeScreenBlurredBackgroundTintColor] saturationDeltaFactor:1.5 maskImage:nil];
    tableHeaderView.backgroundView.image = blurredBackgroundImage;
    
    self.searchBarholder = tableHeaderView;
}

#pragma mark -
#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell"];
        
        IXMSavedProduct *result = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        
        UIImageView *productImage = (UIImageView *)[cell viewWithTag:100];
        UILabel *productName = (UILabel *)[cell viewWithTag:101];
        UILabel *productPrice = (UILabel *)[cell viewWithTag:102];
        UILabel *availableStores = (UILabel *)[cell viewWithTag:103];
        
        // DebugLog(@" product result.. %@",result);
        productName.text = result.name;
        NSString *price = result.priceRangeLabel;
        productPrice.text = price;
        
        NSNumber *avaialbleStore = [NSNumber numberWithInt:[result.noOfStores intValue]];
        if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:0]]) {
            availableStores.text = @"";
        } else if ([avaialbleStore isEqualToNumber:[NSNumber numberWithInt:1]]) {
            availableStores.text = [NSString stringWithFormat:@"Available in %@ Store",avaialbleStore];
        }
        else {
            availableStores.text = [NSString stringWithFormat:@"Available in %@ Stores",avaialbleStore];
        }
        
        [productImage  setImageWithURL:[NSURL URLWithString:result.imageURL] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
        [productImage.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
        [productImage.layer setBorderWidth: 1.0];
        
        
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
        return cell;
    }
    
    return nil;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[self.fetchedResultsController fetchedObjects] count];
    }
    else if (section == 1) {
        NSInteger count = [[self.fetchedResultsController fetchedObjects] count];
        if (count == 0) {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 36;
    }
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        IXMSavedProduct *result = [self.fetchedResultsController objectAtIndexPath:indexPath];
        IXRCatalogViewController *catalogVC = [IXRViewControllerHelper catalogViewControllerWithProduct:result storyboard:self.retailerStoryboard];
        [self.navigationController pushViewController:catalogVC animated:YES];
        
        
    }
    else {
        [self showSearchViewController];
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    [view sizeToFit];
    
    if (section == 0) {
        view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 3, 150, 30)];
        titleLabel.text = @"MY FAVORITES";
        titleLabel.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:123.0/255.0 alpha:1.0];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [view addSubview:titleLabel];
    }
    
    
    
    return view;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0) {
        return nil;
    }
    
    
    if (indexPath.section == 0) {
        UITableViewRowAction *flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Remove from favorites" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // flag the row
            
            // Show a ui on deleting
            IXMSavedProduct *result = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.databaseManager requestRemoveFromFavorites:result forManagedContext:self.managedObjectContext success:^{
                
                NSInteger count = [[self.fetchedResultsController fetchedObjects] count];
                if (count == 0) {
                    [tableView reloadData];
                }
                
                
            } failure:^(NSError *error) {
                // TODO:
            }];
            
            
        }];
        flagAction.backgroundColor = [UIColor redColor];
        
        return @[flagAction];
    }
    return nil;
}

/*
 * EDIT on 06.07.2014 because of some confusion if 'tableView:commitEditingStyle:forRowAtIndexPath:' is needed.
 * It IS needed.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // No statement or algorithm is needed in here. Just the implementation
}


#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IXMSavedProduct"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        NSError *fetchError = nil;
        if (![_fetchedResultsController performFetch:&fetchError]) {
            NSLog(@"Error performing fetch: %@", fetchError);
        }
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"FRC will change content");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"FRC content changed");
    [self.tableView endUpdates];
}

#pragma mark - Open Url Handler delegates
- (void)handleOpenUrlCallForSearch:(NSString *)query {
    [self showSearchViewController];
}

- (void)handleOpenUrlCallOfCaltalogForProduct:(NSString *)mpid {
    IXRCatalogViewController *catalogVC = [IXRViewControllerHelper catalogViewControllerWithProductMpid:mpid storyboard:self.retailerStoryboard];
    [self.navigationController popToViewController:self animated:YES];
    [self.navigationController pushViewController:catalogVC animated:YES];
}

- (void)handleOpenUrlOfType:(NSString *)type parameters:(NSDictionary *)parameters {
    
}

@end

//
//  IXRCatalogPriceViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCatalogPriceViewController.h"
#import <PBWebViewController.h>
#import "PBSafariActivity.h"
#import "IXRetailerHelper.h"
#import <UIImageView+AFNetworking.h>
#import "IXMPriceAggregator.h"

@interface IXRCatalogPriceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleViewLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshViewIndicator;

@property (nonatomic, strong) UIActivityIndicatorView *loadingMoreView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;


@property (nonatomic, strong) NSMutableArray *priceAggregator;
@property (nonatomic, assign) BOOL isLoadingMorePrices;

@end

@implementation IXRCatalogPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isLoadingMorePrices = NO;
    self.operationManager = [IXRetailerHelper getRequestOperationManager];
    self.priceAggregator = [[NSMutableArray alloc] init];
    
    self.loadingMoreView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingMoreView setFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableFooterView = self.loadingMoreView;
    
    
    // Set Up
    [self setUpTitle];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.operationManager.operationQueue cancelAllOperations];
    [super viewDidDisappear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    self.refreshViewIndicator.hidden = ![self isFetchingProductinformation];
    if (!self.refreshViewIndicator.hidden) {
        [self.refreshViewIndicator startAnimating];
    }
    [self refreshAggregatedProductInformation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.priceAggregator) {
        return self.priceAggregator.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"productPriceCell"];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
    UILabel *descLabel = (UILabel *)[cell viewWithTag:12];
    
    IXMPriceAggregator *priceObj = [self.priceAggregator objectAtIndex:indexPath.row];
    
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:priceObj.storeName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0]}]];
    
    
    titleLabel.attributedText = titleString;
    
    descLabel.attributedText = [[NSAttributedString alloc] initWithString:priceObj.priceRange attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithRed:198.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0]}];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:13];
    
    if (priceObj.imageUrl) {
        [imageView  setImageWithURL:[NSURL URLWithString:priceObj.imageUrl] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
        [imageView.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
        [imageView.layer setBorderWidth: 1.0];

    }
    else {
        [imageView  setImage:[UIImage imageNamed:@"icon-default-picture.png"]];
        [imageView.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
        [imageView.layer setBorderWidth: 1.0];

    }
    
    UILabel *avaialbilitylabel = (UILabel *)[cell viewWithTag:15];
    if (priceObj.availabilityStatus && [priceObj.availabilityStatus isEqualToString:@"OUT_OF_STOCK"]) {
        avaialbilitylabel.text = @"OUT OF STOCK";
        avaialbilitylabel.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        avaialbilitylabel.hidden = NO;
    }
    else {
        avaialbilitylabel.hidden = YES;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IXMPriceAggregator *priceObj = [self.priceAggregator objectAtIndex:indexPath.row];
    NSString *url = priceObj.productUrl;
    PBWebViewController *webViewController = [[PBWebViewController alloc] init];
    webViewController.URL = [NSURL URLWithString:url];
    PBSafariActivity *activity = [[PBSafariActivity alloc] init];
    webViewController.applicationActivities = @[activity];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [self.priceAggregator count]-1) {
        [self lazyLoadProducts];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

#pragma mark - Lazy load products
- (void) lazyLoadProducts{
    if (!self.isLoadingMorePrices && [IXRetailerHelper isPaginationPossibleForOffersInStores:self.pricePageNumber + 1 andTotalCount:self.totalPriceOfferCount]) {
        [self performLoadMoreOperation];
    }
}

- (void)performLoadMoreOperation {
    NSLog(@"loading product page %ld", (long)self.pricePageNumber + 1);
    self.isLoadingMorePrices = YES;
    self.loadingMoreView.hidden = NO;
    [self.loadingMoreView startAnimating];
    
    [self.operationManager.operationQueue cancelAllOperations];
    [IXRetailerHelper requestProductOffersForProduct:self.product page:[NSString stringWithFormat:@"%lu", (unsigned long)self.pricePageNumber + 1] withManager:self.operationManager success:^(AFHTTPRequestOperation *operation, NSArray *productprices, NSInteger offerCount) {
        [self addPricesFromArray:productprices forPage:self.pricePageNumber + 1];
        
        self.loadingMoreView.hidden = YES;
        [self refreshAggregatedProductInformation];
        self.isLoadingMorePrices = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.loadingMoreView.hidden = YES;
        self.isLoadingMorePrices = NO;
    }];
}


#pragma mark - Utilities

- (void)setUpTitle {
    self.titleViewLabel.text = [self productTitle];
}

- (void)startingProductDetailfetch {
    self.refreshViewIndicator.hidden = NO;
    [self.refreshViewIndicator startAnimating];
}

- (void)productDetailfetchFinished:(BOOL)isSuccess {
    self.refreshViewIndicator.hidden = YES;
    [self refreshAggregatedProductInformation];
}


- (void)refreshAggregatedProductInformation {
    [self.priceAggregator removeAllObjects];
    
    NSArray *productPriceArray = self.productPriceArray;
    if (productPriceArray) {
        IXMPriceAggregator *priceAggObject = nil;
        IXMProductPrice *lastPrice = nil;
        for (IXMProductPrice *object in productPriceArray) {
            if (lastPrice) {
                if ([lastPrice.imageUrl isEqualToString:object.imageUrl]) {
                    [priceAggObject addPriceObject:object];
                }
                else {
                    priceAggObject = [[IXMPriceAggregator alloc] initWithPricePoint:object];
                    lastPrice = object;
                    [self.priceAggregator addObject:priceAggObject];
                }
            }
            else {
                priceAggObject = [[IXMPriceAggregator alloc] initWithPricePoint:object];
                lastPrice = object;
                [self.priceAggregator addObject:priceAggObject];
            }
            
        }
    }
    
    [self.tableView reloadData];
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

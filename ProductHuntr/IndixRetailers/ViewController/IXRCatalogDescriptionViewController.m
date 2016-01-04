//
//  IXRCatalogDescriptionViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 27/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCatalogDescriptionViewController.h"
#import <UIImageView+AFNetworking.h>
#import "IXRUtils.h"
#import "IXMProductDescriptionAttributes.h"
#import "IXRetailerHelper.h"
#import "IXRViewUtils.h"


@interface IXRCatalogDescriptionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshViewIndicator;

@property (nonatomic, weak) UITextField *feedbackTextInputField;

@end

@implementation IXRCatalogDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    // Set Up
    [self setUpTitle];
    
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    self.refreshViewIndicator.hidden = ![self isFetchingProductinformation];
    if (!self.refreshViewIndicator.hidden) {
        [self.refreshViewIndicator startAnimating];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

#define DEFAULT_FONT_HEIGHT 13.0

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self productDetail] != nil) {
        return 4;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self productDetail] != nil) {
        if (section == 0 || section == 1) {
            return 1;
        }
        if (section == 2) {
            return 3;
        }
        if (section == 3) {
            return self.productDetail.productDescriptionArray.count;
        }
        if (section == 4) {
            return 1;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160;
    }
    else if (indexPath.section == 1) {
        return 50;
    }
    else if (indexPath.section == 2) {
        return 44;
    }
    else if (indexPath.section == 3) {
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"productImageCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:11];
        [imageView  setImageWithURL:[NSURL URLWithString:self.productDetail.imageURL] placeholderImage:[UIImage imageNamed:@"icon-default-picture.png"]];
        [imageView.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
        [imageView.layer setBorderWidth: 1.0];
        
    }
    else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"productTitleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *priceLabel = (UIButton *)[cell viewWithTag:12];
        UIButton *favorites = (UIButton *)[cell viewWithTag:13];
        UIButton *storesLabel = (UIButton *)[cell viewWithTag:14];
        [favorites addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteButtonTapped:)]];
        [priceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceButtonTapped:)]];
        [storesLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeButtonTapped:)]];
        
        [favorites setEnabled:!self.isDoingFavouriting];
        if (self.isAddedtoFavorites) {
            [favorites setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        }
        else {
            [favorites setTitle:@"Add to favorites" forState:UIControlStateNormal];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[self productOffers] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:DEFAULT_FONT_HEIGHT], NSForegroundColorAttributeName:[UIColor colorWithRed:198.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0]}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        
        [priceLabel setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        NSMutableAttributedString *storeattributedString = [[NSMutableAttributedString alloc] init];
        NSString *storeString = [NSString stringWithFormat:@"%@ stores >", [self storeCount]];
        
        [storeattributedString appendAttributedString:[[NSAttributedString alloc] initWithString:storeString attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:DEFAULT_FONT_HEIGHT], NSForegroundColorAttributeName:[UIColor colorWithRed:67.0/255.0 green:160.0/255.0 blue:71.0/255.0 alpha:1.0]}]];
        
        [storesLabel setAttributedTitle:storeattributedString forState:UIControlStateNormal];
    }
    
    else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"productInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        UILabel *descLabel = (UILabel *)[cell viewWithTag:12];
        
        NSDictionary *fontDictionery;
        NSString *title;
        NSString *desc;
        if (indexPath.row == 0) {
            fontDictionery = @{NSFontAttributeName:[UIFont systemFontOfSize:DEFAULT_FONT_HEIGHT], NSForegroundColorAttributeName:[UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:0.0/255.0 alpha:1.0]};
            title = @"BRAND";
            desc = self.productDetail.brandName;
        }
        else if (indexPath.row == 1) {
            fontDictionery = @{NSFontAttributeName:[UIFont systemFontOfSize:DEFAULT_FONT_HEIGHT], NSForegroundColorAttributeName:[UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:0.0/255.0 alpha:1.0]};
            title = @"CATEGORY";
            desc = self.productDetail.categoryName;
        }
        else if (indexPath.row == 2) {
            title = @"UPC";
            desc = self.productDetail.upcNumber;
        }
        else if (indexPath.row == 3) {
            title = @"MPN";
            desc = self.productDetail.mpnNumber;
        }
        else {
            
        }
        
        if (!fontDictionery) {
            fontDictionery = @{NSFontAttributeName:[UIFont systemFontOfSize:DEFAULT_FONT_HEIGHT], NSForegroundColorAttributeName:[UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0]};
        }
        
        if (!desc) {
            desc = @"NA";
        }
        
        NSAssert(title != nil , @"In IXRCatalogDescriptionViewController tableview, section 3 title cannot be nil");
        
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:fontDictionery];
        descLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", desc] attributes:fontDictionery];
        
    }
    else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productAttrCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        UILabel *descLabel = (UILabel *)[cell viewWithTag:12];
        
        IXMProductDescriptionAttributes *attr = [self.productDetail.productDescriptionArray objectAtIndex:indexPath.row];
        
        titleLabel.text = attr.title;
        descLabel.text = attr.value;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Utilities

- (void)favoriteButtonTapped:(UIButton *)button
{
    // Add/Remove from favorites
    [self doToggleFavoritesOption];
}

- (void)priceButtonTapped:(id)sender {
    [self doShowAllPrices];
}

- (void)storeButtonTapped:(id)sender {
    [self doShowAllPrices];
}

- (void)setUpTitle {
    self.titleLabel.text = [self productTitle];
}

- (void)startingProductDetailfetch {
    self.refreshViewIndicator.hidden = NO;
    [self.refreshViewIndicator startAnimating];
}

- (void)productDetailfetchFinished:(BOOL)isSuccess {
    self.refreshViewIndicator.hidden = YES;
    [self.tableView reloadData];
}

- (void)startingFavoritesChange {
    [self.tableView reloadData];
}

- (void)favoritesChangeFinished:(BOOL)isSuccess {
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

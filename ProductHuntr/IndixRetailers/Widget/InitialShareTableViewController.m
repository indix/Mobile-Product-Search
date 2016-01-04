//
//  InitialShareTableViewController.m
//  RetailerApp
//
//  Created by Nalin Chhajer on 21/10/15.
//  Copyright © 2015 indix. All rights reserved.
//

#import "InitialShareTableViewController.h"
#import <UIImageView+AFNetworking.h>
#import "IXRetailerHelper.h"
#import "IXProduct.h"
#import "IXWSearchProductResultsCell.h"
#import "ShareViewController.h"
#import "IXRetailerHelperConfig.h"

@interface InitialShareTableViewController ()<UITableViewDataSource, UITableViewDelegate, ShareViewControllerDelegate> {
    NSInteger totalAttachment;
}

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *inputSharedString;

@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation InitialShareTableViewController

- (BOOL)isContentValid {
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    NSArray *atatchments = item.attachments;
    for (NSItemProvider  *itemProvider in atatchments) {
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
            return YES;
        }
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[IXRetailerHelperConfig instance] setConfigFrompList:@"local_config"];
    self.operationManager = [IXRetailerHelper getRequestOperationManager];
    
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
    
    self.inputSharedString = [[NSMutableString alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.emptyView.hidden = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.errorView.hidden = YES;
    
    // Get the item[s] we're handling from the extension context.
    // In our Action extension, we only need one input item (text), so we use the first item from the array.
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    
    NSArray *atatchments = item.attachments;
    totalAttachment = atatchments.count;
    for (NSItemProvider  *itemProvider in atatchments) {
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
            
            // Do even for url
            
            // It's a plain text!
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
                
                if (item) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        totalAttachment --;
                        [self updateText:item];
                    }];
                }
            }];
        }
        
        else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                // Maybe it's just a URL
                // May want to use sharedPlainText as well, maybe as the title
                
                if (item) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        totalAttachment --;
                        [self updateUrl:url];
                    }];
                }
            }];
        }
        else {
            totalAttachment --;
            [self update];
        }
    }
    
}


- (void)updateText:(NSString *)text {
    [self.inputSharedString appendString:@" "];
    [self.inputSharedString appendString:text];
    [self update];
}

- (void)updateUrl:(NSURL *)text {
    [self.inputSharedString appendString:@" "];
    [self.inputSharedString appendString:[text absoluteString]];
    [self update];
}

- (void)update {
    if (totalAttachment <= 0) {
        [self refreshWithShareText:self.inputSharedString];
    }
}

- (void)refreshWithShareText:(NSString *)shareText {
    if ([[shareText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0) {
        [IXRetailerHelper requestSearchProductFromShareText:shareText page:nil sortBy:nil withManager:self.operationManager success:^(AFHTTPRequestOperation *operation, NSArray *productsArray, NSInteger count) {
            self.productArray = productsArray;
            [self.tableView reloadData];
            if (productsArray.count == 0) {
                self.activityIndicator.hidden = YES;
                self.emptyView.hidden = YES;
                self.errorView.hidden = NO;
            }
            else {
                if (productsArray.count == 1) {
                    [self showShareViewControllerWithProduct:[productsArray objectAtIndex:0] enableback:NO];
                }
                // TODO:
                self.activityIndicator.hidden = YES;
                self.emptyView.hidden = YES;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.activityIndicator.hidden = YES;
            self.emptyView.hidden = YES;
            self.errorView.hidden = NO;
        }];
    }
    else {
        NSLog(@"Was not able to decode character");
        self.errorView.hidden = NO;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneTapped:(id)sender {
    [self close];
}

- (IBAction)goToSearchTap:(id)sender {
    NSString *shareStringIdentifier = [[IXRetailerHelperConfig instance] shareWidgetIdentifier];
    ;
    [self openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",shareStringIdentifier, @"://product_search"]]];
    [self close];
}

- (void)close {
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (void)openUrl:(NSURL *)url {
    
    NSString *className = @"UIApplication";
    if ( NSClassFromString( className ) )
    {
        id object = [ NSClassFromString( className ) performSelector: @selector( sharedApplication ) ];
        [ object performSelector: @selector( openURL: ) withObject: url ];
    }
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ProductCellIdentifier = @"ProductResultsCell";
    
    IXWSearchProductResultsCell *productResultCell =  [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
    NSArray *nibArray;
    if (productResultCell == nil) {
        nibArray = [[NSBundle mainBundle] loadNibNamed:@"IXWSearchProductResultsCell" owner:self options:nil];
        productResultCell = [nibArray objectAtIndex:0];
    }
    IXProduct *result;
    if ([self.productArray count]>0) {
        result = [self.productArray objectAtIndex:[indexPath row]];
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
   
    
    
    return productResultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IXProduct *result = [self.productArray objectAtIndex:[indexPath row]];
    [self showShareViewControllerWithProduct:result enableback:YES];
}

- (void)showShareViewControllerWithProduct:(IXProduct *)product enableback:(BOOL)back {
    ShareViewController *sharevc = [self.storyboard instantiateViewControllerWithIdentifier:@"shareVC"];
    sharevc.product = product;
    sharevc.showBack = back;
    sharevc.delegate = self;
    sharevc.operationManager = self.operationManager;
    sharevc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:sharevc animated:NO completion:^{
        
    }];
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

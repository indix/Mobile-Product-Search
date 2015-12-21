//
//  IXRProductFilterViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRProductFilterViewController.h"
#import "IXRUtils.h"
#import "IXRetailerHelper.h"
#import <MBProgressHUD.h>
#import "IXMCategoryFilterViewTableViewCell.h"

@interface IXRProductFilterViewController () < UITableViewDataSource, UITableViewDelegate, IXMCategoryFilterViewTableViewCellDelegate, IXMDisplayCategoryFilterDelagete, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (nonatomic, strong) UIBarButtonItem *clearButton;

@property (nonatomic, strong) UITextField *currentSelectedField;
@property (nonatomic, strong) UITapGestureRecognizer *currentGestureRecognizer;

@end

@implementation IXRProductFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationBar];
    [self setUpSegmentControl];
    [self setUptableView];
    [self setUPCategoryDisplayArray];
    
    if (!self.selectedFilters) {
        self.selectedFilters = [[IXMSelectedFilters alloc] init];
    }
 
    [self resetFilterTitle];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if ([self.segmentControl selectedSegmentIndex] == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
        
        IXMBrandFilter *filter = [self.filterObjects.brandFilters objectAtIndex:indexPath.row];
        
        UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
        
        textLabel.attributedText = [self attributeFromTitle:filter.name count:[IXRUtils shortStringForInteger:[filter.count integerValue]]];
        
        if ([self.selectedFilters isBrandSelected:filter]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if ([self.segmentControl selectedSegmentIndex] == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
        
        IXMStoreFilter *filter = [self.filterObjects.storeFilters objectAtIndex:indexPath.row];
        UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
        
        textLabel.attributedText = [self attributeFromTitle:filter.name count:[IXRUtils shortStringForInteger:[filter.count integerValue]]];
        
        if ([self.selectedFilters isStoreSelected:filter]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if ([self.segmentControl selectedSegmentIndex] == 3) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
            
            UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
            
            NSString *availabilityType = kIXRAvailabilityAll;
            if (indexPath.row == 1) {
                availabilityType = kIXRAvailabilityInStock;
            }
            else if (indexPath.row == 2) {
                availabilityType = kIXRAvailabilityOutOfStock;
            }
            
            NSString *title = @"ALL";
            if ([availabilityType isEqualToString:kIXRAvailabilityInStock]) {
                title = @"IN STOCK";
            }
            else if ([availabilityType isEqualToString:kIXRAvailabilityOutOfStock]) {
                title = @"OUT OF STOCK";
            }
            
            textLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]}];
            
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (self.selectedFilters.availabilityFilterType) {
                if (indexPath.row == 0 && [self.selectedFilters.availabilityFilterType isEqualToString:kIXRAvailabilityAll]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else if (indexPath.row == 1 && [self.selectedFilters.availabilityFilterType isEqualToString:kIXRAvailabilityInStock]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else if (indexPath.row == 2 && [self.selectedFilters.availabilityFilterType isEqualToString:kIXRAvailabilityOutOfStock]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            else {
                if (indexPath.row == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            
            return cell;
        }
        else if (indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceRangeCell"];
            UITextField *minLabel = (UITextField *)[cell viewWithTag:10];
            UITextField *maxLabel = (UITextField *)[cell viewWithTag:11];
            minLabel.delegate = self;
            maxLabel.delegate = self;
            
            if (self.selectedFilters.minPrice == -1) {
                minLabel.text = @"";
            }
            else {
                minLabel.text = [NSString stringWithFormat:@"%0.2f", self.selectedFilters.minPrice];
            }
            
            if (self.selectedFilters.maxPrice == -1) {
                maxLabel.text = @"";
            }
            else {
                maxLabel.text = [NSString stringWithFormat:@"%0.2f", self.selectedFilters.maxPrice];
            }
            
            
            minLabel.textColor = [UIColor blackColor];
            if (self.selectedFilters.minPrice > self.selectedFilters.maxPrice) {
                maxLabel.textColor = [UIColor redColor];
            }
            else {
                maxLabel.textColor = [UIColor blackColor];
            }
            
            UIToolbar* toolbar = [UIToolbar new];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
            id space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            toolbar.items = @[space, doneButton];
            
            minLabel.inputAccessoryView = toolbar;
            maxLabel.inputAccessoryView = toolbar;
            
            [minLabel addTarget:self
                          action:@selector(calculateAndUpdateTextFields:)
                forControlEvents:UIControlEventEditingChanged];
            
            [maxLabel addTarget:self
                          action:@selector(calculateAndUpdateTextFields:)
                forControlEvents:UIControlEventEditingChanged];
            
            return cell;
        }
        
    }
    else if ([self.segmentControl selectedSegmentIndex] == 0) {
        
        IXMCategoryFilterViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        
        IXMCategoryFilter *filter = [self.categoryDisplay objectAtIndex:indexPath.row];
        UILabel *textLabel = cell.title;
        
        textLabel.attributedText = [self attributeFromTitle:filter.name count:[IXRUtils shortStringForInteger:[filter.count integerValue]]];
        
        
        if ([self.selectedFilters isCategorySelected:filter]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.filter = filter;
        cell.delegate = self;
        
        
        float minMarginLeftConstraint = 8;
        float marginConstant = 16 * filter.treeIndex + minMarginLeftConstraint;
        cell.plusLeftMargin.constant = marginConstant;
        
        
        
        if (filter.isLastLeaf) {
            cell.plusButton.hidden = YES;
            cell.minusbutton.hidden = YES;
            cell.plusButton.enabled = NO;
            cell.minusbutton.enabled = NO;
        }
        else {
            if (filter.isSubCategoryDownloaded) {
                cell.plusButton.hidden = YES;
                cell.minusbutton.hidden = NO;
                cell.plusButton.enabled = NO;
                cell.minusbutton.enabled = YES;
            }
            else {
                cell.plusButton.hidden = NO;
                cell.minusbutton.hidden = YES;
                cell.plusButton.enabled = YES;
                cell.minusbutton.enabled = NO;
            }
        }
        
        return cell;
        
        
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.segmentControl selectedSegmentIndex] == 3) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.segmentControl selectedSegmentIndex] == 1) {
        return [self.filterObjects.brandFilters count];
    }
    else if ([self.segmentControl selectedSegmentIndex] == 2) {
        return [self.filterObjects.storeFilters count];
    }
    else if ([self.segmentControl selectedSegmentIndex] == 3) {
        if (section == 0) {
            return 3;
        }
        else if (section == 1) {
            return 1;
        }
        return 0;
    }
    else if ([self.segmentControl selectedSegmentIndex] == 0) {
        return [self.categoryDisplay count];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.segmentControl selectedSegmentIndex] == 1) {
        IXMBrandFilter *filter = [self.filterObjects.brandFilters objectAtIndex:indexPath.row];
        if ([self.selectedFilters isBrandSelected:filter]) {
            [self.selectedFilters removeBrand:filter];
        }
        else {
            [self.selectedFilters addBrand:filter];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([self.segmentControl selectedSegmentIndex] == 2) {
        IXMStoreFilter *filter = [self.filterObjects.storeFilters objectAtIndex:indexPath.row];
        if ([self.selectedFilters isStoreSelected:filter]) {
            [self.selectedFilters removeStore:filter];
        }
        else {
            [self.selectedFilters addStore:filter];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([self.segmentControl selectedSegmentIndex] == 3) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                self.selectedFilters.availabilityFilterType = kIXRAvailabilityAll;
            }
            else if (indexPath.row == 1) {
                self.selectedFilters.availabilityFilterType = kIXRAvailabilityInStock;
            }
            else if (indexPath.row == 2) {
                self.selectedFilters.availabilityFilterType = kIXRAvailabilityOutOfStock;
            }
            
            [tableView reloadData];
        }
    }
    else if ([self.segmentControl selectedSegmentIndex] == 0) {
        IXMCategoryFilter *filter = [self.categoryDisplay objectAtIndex:indexPath.row];
        
        if ([self.selectedFilters isCategorySelected:filter]) {
            [self.selectedFilters removeCategory:filter];
        }
        else {
            [self.selectedFilters addCategory:filter];
        }
        
        
        [tableView reloadData];
    }
    [self resetFilterTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.segmentControl selectedSegmentIndex] == 3) {
        return 30.0;
    }
    return 1.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Availability";
    }
    else if (section == 1) {
        return @"Price Range";
    }
    
    return @"";
}

- (NSAttributedString *)attributeFromTitle:(NSString *)title count:(NSString *)count {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]}]];
    
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0]}]];
    
    return attributeString;
}

- (void)subCategoryRequiredSelected:(IXMCategoryFilter *)filter {
    
    if (!filter.isSubCategoryDownloaded) {
        [self requestSubCategoryForCategory:filter];
    }
}

- (void)hideSubCategorySelected:(IXMCategoryFilter *)filter {
    if (filter.isSubCategoryDownloaded) {
        [self.categoryDisplay removeAllSubCategoryOfCategory:filter];
        [self.tableView reloadData];
        if (self.delegate) {
            [self.delegate didDownloadAndModifyCategoryDisplay:self.categoryDisplay];
        }
    }
    
}

#pragma mark - Utilities
- (void)segmentValueChanged:(UISegmentedControl *)control {
    [self.tableView reloadData];
    if (self.delegate) {
        [self.delegate didSelectedSegmentAtIndex:control.selectedSegmentIndex];
    }
}

- (void)setUpSegmentControl {
    self.segmentControl.tintColor = [UIColor colorWithRed:251.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0];
    
    [self.segmentControl removeAllSegments];
    [self.segmentControl insertSegmentWithTitle:@"Category" atIndex:0 animated:NO];
    [self.segmentControl insertSegmentWithTitle:@"Brand" atIndex:1 animated:NO];
    [self.segmentControl insertSegmentWithTitle:@"Store" atIndex:2 animated:NO];
    [self.segmentControl insertSegmentWithTitle:@"Others" atIndex:3 animated:NO];
    
    
    [self.segmentControl setSelectedSegmentIndex:self.selectedFilterTabIndex];
    
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void)setUptableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
    
- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterPressed:)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearfilterPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[filterButton];
    self.filterButton = filterButton;
    self.clearButton = clearButton;
    
}

- (void)clearfilterPressed:(id)sender {
    [self.selectedFilters clearFilters];
    [self.tableView reloadData];
    [self resetFilterTitle];
    if (self.delegate) {
        [self.delegate didAskForClearFilter];
    }
}

- (void)resetFilterTitle {
    NSInteger count = [self.selectedFilters selectedCount];
    if (count == 0) {
        self.filterButton.title = @"Apply";
    }
    else {
        self.filterButton.title = [NSString stringWithFormat:@"Apply (%d)", (int)count];
    }
}

- (void)cancelPressed:(id)sender {
    [self.delegate didCancelFilter];
}

- (void)filterPressed:(id)sender {
    if (self.delegate) {
        [self.delegate doFiltersForSelectedFilter:self.selectedFilters];
    }
}

- (void)requestSubCategoryForCategory:(IXMCategoryFilter *)categoryFilter  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait!!!";
    
    [IXRetailerHelper requestSubCategoryFacetsForQuery:self.searchQuery forCategory:categoryFilter withManager:nil success:^(AFHTTPRequestOperation *operation, NSInteger count, IXMFilterObjects *filter) {
        
        [self.categoryDisplay addSubCategoryForCategory:categoryFilter subCategory:filter.categoryFilters];
        [self.tableView reloadData];
        [hud hide:YES];
        if (self.delegate) {
            [self.delegate didDownloadAndModifyCategoryDisplay:self.categoryDisplay];
        }
        // Move to the position
        if (!categoryFilter.isLastLeaf) {
            NSInteger index = [self.categoryDisplay indexPositionOfCategory:categoryFilter];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (void)setUPCategoryDisplayArray {
    if (!self.categoryDisplay) {
        self.categoryDisplay = [[IXMDisplayCategoryFilter alloc] initWithInitialCategory:self.filterObjects.categoryFilters];
    }
    self.categoryDisplay.delegate = self;
}

- (void)willDeleteSubCategory:(IXMCategoryFilter *)filter {
    if ([self.selectedFilters isCategorySelected:filter]) {
        [self.selectedFilters removeCategory:filter];
    }
    [self resetFilterTitle];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // return NO to disallow editing.
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // became first responder
    self.currentSelectedField = textField;
    
    if (!self.currentGestureRecognizer) {
        self.currentGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardOnTableTap:)];
        [self.tableView addGestureRecognizer:self.currentGestureRecognizer];
    }
    

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    self.currentSelectedField = nil;
    if (self.currentGestureRecognizer) {
        [self.tableView removeGestureRecognizer:self.currentGestureRecognizer];
        self.currentGestureRecognizer = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // return NO to not change text
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    // called when clear button pressed. return NO to ignore (no notifications)
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

- (void)calculateAndUpdateTextFields:(UITextField *)textField {
    if (textField.tag == 10) {
        // min price
        double givenPrice = [textField.text doubleValue];
        self.selectedFilters.minPrice = givenPrice;
    }
    else if (textField.tag == 11) {
        // max price
        double givenPrice = [textField.text doubleValue];
        self.selectedFilters.maxPrice = givenPrice;
        if (self.selectedFilters.minPrice > self.selectedFilters.maxPrice) {
            textField.textColor = [UIColor redColor];
        }
        else {
            textField.textColor = [UIColor blackColor];
        }
    }

}

- (IBAction)dismissKeyboard:(id)sender {
    [self dismissKeyboardOnTableTap:sender];
}

- (void)dismissKeyboardOnTableTap:(id)sender {
    if (self.currentSelectedField) {
        [self.currentSelectedField resignFirstResponder];
        self.currentSelectedField = nil;
        if (self.currentGestureRecognizer) {
            [self.tableView removeGestureRecognizer:self.currentGestureRecognizer];
            self.currentGestureRecognizer = nil;
        }
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.currentSelectedField.frame.origin) ) {
        [self.tableView scrollRectToVisible:self.currentSelectedField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

@end

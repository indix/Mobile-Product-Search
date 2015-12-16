//
//  IXRSearchDisplayViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 14/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRSearchDisplayViewController.h"
#import <REMenu.h>

#import "IXRetailerHelper.h"
#import "IXSearchSuggestionHelper.h"
#import "IXRSearchSuggestionTableView.h"
#import "IXRProductListViewController.h"

@interface IXRSearchDisplayViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IXRSearchSuggestionTableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *searchHolder;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *searchDropDownButton;

@property (nonatomic, strong) REMenu *dropDownMenu;

@property (nonatomic, strong) NSMutableArray *dropDownItems;

@property (nonatomic, assign) NSInteger selectedDropDownIndexPath;

@property (nonatomic, strong) IXRSearchSuggestionTableView *searchTableView;

@property (nonatomic, strong) NSArray * recentSearchItems;

@end

@implementation IXRSearchDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.recentSearchItems = @[];
    
    [self setUpSearchBar];
    [self setUpSearchDropDownMenu];
    [self setUpSearchSuggestions];
    [self setUpRecentlySearch];
//    [self hideKeyboardInit];
    
    [self selectDropDownItemAtPosition:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [self refreshRecentItems];
    
    [super viewWillAppear:animated];
    [self.searchField becomeFirstResponder];
}

- (void)refreshRecentItems {
    [IXRetailerHelper retreiveRecentlySearchItemWithResult:^(NSArray *objects, NSError *error) {
        self.recentSearchItems = objects;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recentlySearchCell"];
    
    IXMRecentSearchItem *dict = [self.recentSearchItems objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
    
    NSString *type = dict.type;
    
    if (![type isEqualToString:kIXRSearchTypeAll]) {
        IXMSearchType *searchType = [IXMSearchType getSearchtypeForKey:type];

        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", searchType.title] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0]}]];
    }
    
    
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:dict.query attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithRed:241.0/255.0 green:54.0/255.0 blue:28.0/255.0 alpha:1.0]}]];
    
    label.attributedText = string;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recentSearchItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect tableRect = CGRectMake(0, 0, self.tableView.frame.size.width, 40.0);
    UIView *headerView = [[UIView alloc] initWithFrame:tableRect];
    
    UILabel * label = [[UILabel alloc] initWithFrame:tableRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc] initWithString:@"RECENT SEARCHES" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:123.0/255.0 alpha:1.0]}];
    
    [headerView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, tableRect.size.height - 1, self.tableView.frame.size.width - 32, 1.0)];
    [line setBackgroundColor:[UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:123.0/255.0 alpha:1.0]];
    [headerView addSubview:line];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.searchTableView cancelSearchSuggestionOperation];
    
    IXMRecentSearchItem *dict = [self.recentSearchItems objectAtIndex:indexPath.row];
    
    // Save in recent searches if it is success.
    IXRProductListViewController *productVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productListVC"];
    IXMSearchType *searchType = [IXMSearchType getSearchtypeForKey:dict.type];
    productVC.searchtype = searchType;
    productVC.searchQuery = dict.query;
    [self.navigationController pushViewController:productVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 
#pragma mark Utilities

#define SEARCH_UTILITIES_DICTIONARY @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithRed:239.0/255.0 green:56.0/255.0 blue:36.0/255.0 alpha:1.0]}

- (void)setUpSearchBar {
    
    float width = self.view.frame.size.width;
    int padding = 10.0;
    int searchbarheight = 44;
    int topSpacing = 40;
    
    
    CGRect searchBarRect = CGRectMake(padding, topSpacing, width - (padding * 2), searchbarheight);
    UIView *searchBar = [[UIView alloc] initWithFrame:searchBarRect];
    searchBar.backgroundColor = [UIColor whiteColor];
    [searchBar.layer setCornerRadius:5.0f];
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, searchBar.frame.size.width - 55, searchBar.frame.size.height)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.delegate = self;
    searchBar.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    searchBar.accessibilityLabel = @"leftButton";
    searchBar.layer.borderWidth = 1.0f;
    [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, searchbarheight)];
    [leftButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onshowSearchDropDownMenuTapped)]];
    searchField.leftView = leftButton;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    leftButton.accessibilityLabel = @"leftButton";
    
    
    UIButton *searchRightView = [[UIButton alloc] initWithFrame:CGRectMake(searchField.frame.size.width, 0, 55, searchbarheight)];
    [searchRightView setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:SEARCH_UTILITIES_DICTIONARY] forState:UIControlStateNormal];
    [searchRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSearch)]];
    searchRightView.accessibilityLabel = @"searchRightView";
    [searchBar addSubview:searchRightView];
    
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeyGo;
    searchField.accessibilityLabel = @"searchField";
    searchField.placeholder = @"Search All Products";
    [searchBar addSubview:searchField];
    
    [self.view addSubview:searchBar];
    self.searchHolder = searchBar;
    self.searchField = searchField;
    self.searchDropDownButton = leftButton;
    
    
    
    
    if (self.isFromHomeViewController) {
        CGRect fromRect = self.homeSearchRect;
        CGRect toRect = searchBarRect;
        searchBar.frame = fromRect;
        [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            searchBar.frame = toRect;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    [self registerForKeyboardNotifications];

}

- (void)setTextForSearchDropDownButton:(NSString *)string {
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[string stringByAppendingString:@" "] attributes:SEARCH_UTILITIES_DICTIONARY];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"drop_down_icon.png"];
    attachment.bounds = CGRectMake(-2.0, -1.0, 16, 12);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    [myString appendAttributedString:attachmentString];
    [self.searchDropDownButton setAttributedTitle:myString forState:UIControlStateNormal];
}

- (void)showSearchDropDownMenu {
    
    CGRect searchholderRect = self.searchHolder.frame;
    searchholderRect.origin.y = searchholderRect.origin.y + searchholderRect.size.height - 5;
    searchholderRect.origin.x = searchholderRect.origin.x;
    searchholderRect.size.width = searchholderRect.size.width;
    searchholderRect.size.height = 210;
    
    
    [self.dropDownMenu showFromRect:searchholderRect inView:self.view];
    
    // on open
    [self onSearchBarDropDownOpen];
}

- (void)setUpRecentlySearch {
    self.tableView.alpha = 0;
    [UIView animateWithDuration:0.1 delay:0.6 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSearchDropDownMenu {
    [self.dropDownMenu closeWithCompletion:^{
        [self onSearchBarDropDownClose];
    }];
    
}

- (void)onshowSearchDropDownMenuTapped {
    if (self.dropDownMenu.isOpen) {
        [self hideSearchDropDownMenu];
    }
    else {
        [self showSearchDropDownMenu];
    }
}

- (void)onSearchBarDropDownOpen {
    self.searchHolder.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];

}

- (void)onSearchBarDropDownClose {
    self.searchHolder.backgroundColor = [UIColor whiteColor];
}

- (void)onSearchDropDownMenuItemSelected:(REMenuItem *)item {
    [self selectDropDownItemAtPosition:item.tag];
}

- (void)selectDropDownItemAtPosition:(NSInteger)integer {
    self.selectedDropDownIndexPath = integer;
    IXMSearchType * item = [self.dropDownItems objectAtIndex:integer];
    [self setTextForSearchDropDownButton:item.title];
    if (integer == 0) {
        self.searchField.placeholder = @"eg. iPod, nike shoes";
        [self.searchTableView showSearchSuggestionForFurtherSearch:YES];
    }
    else {
        self.searchField.placeholder = [item.title stringByAppendingString:@" number"];
        [self.searchTableView showSearchSuggestionForFurtherSearch:NO];
    }
    self.searchField.text = @"";
}

- (void)setUpSearchDropDownMenu {
    
    self.dropDownItems = [[NSMutableArray alloc] init];
    NSArray *array = [IXMSearchType getAllSearchTypes];
    for (id object in array) {
        [self.dropDownItems addObject:object];
    }
    
    NSMutableArray *menuItemARray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.dropDownItems.count; i++) {
        IXMSearchType * item = [self.dropDownItems objectAtIndex:i];
        REMenuItem *Item = [[REMenuItem alloc] initWithTitle:item.title
                                                        subtitle:nil
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self onSearchDropDownMenuItemSelected:item];
                                                          }];
        Item.tag = i;
        [menuItemARray addObject:Item];

    }
    
    
    self.dropDownMenu = [[REMenu alloc] initWithItems:menuItemARray];
    [self.dropDownMenu setAccessibilityLabel:@"DropDownMenu"];
    self.dropDownMenu.cornerRadius = 5.0;
    self.dropDownMenu.shadowColor = [UIColor blackColor];
    self.dropDownMenu.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.dropDownMenu.shadowOpacity = 0.1f;
    self.dropDownMenu.itemHeight = 50;
    self.dropDownMenu.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.dropDownMenu.separatorColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    self.dropDownMenu.separatorHeight = 1.0;
    self.dropDownMenu.font = [UIFont systemFontOfSize:14.0];
    self.dropDownMenu.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.dropDownMenu.textAlignment = NSTextAlignmentLeft;
    self.dropDownMenu.textOffset = CGSizeMake(10, 0);
    self.dropDownMenu.borderColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    self.dropDownMenu.bounce = NO;
    
    
}

- (void)hideKeyboardInit {
    /**
     Single tapping anywhere on the chat table view to hide the keyboard
     */
    UITapGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    hideKeyboard.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:hideKeyboard];
}

- (void)hideKeyboard{
    [self cancelSearch];
}

- (void)cancelSearch {
    
    
    if (self.isFromHomeViewController) {
        [self hideSearchDropDownMenu];
        [self.tableView setHidden:YES];
        [self.searchTableView setHidden:YES];
        [self.searchField setText:@""];
        [self.searchField resignFirstResponder];
        CGRect toRect = self.homeSearchRect;
        [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            self.searchHolder.frame = toRect;
        } completion:^(BOOL finished) {
            // Animating
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
    }
    else {
        // Animating
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    
    
    
}

#pragma mark - Search Suggestions helpers and methods

- (void)setUpSearchSuggestions {
    
    CGRect searchholderRect = self.searchHolder.frame;
    searchholderRect.origin.y = searchholderRect.origin.y + searchholderRect.size.height + 10;
    searchholderRect.origin.x = searchholderRect.origin.x;
    searchholderRect.size.width = searchholderRect.size.width;
    searchholderRect.size.height = self.view.frame.size.height - searchholderRect.origin.y - 100;
    
    self.searchTableView = [[IXRSearchSuggestionTableView alloc] initWithFrame:searchholderRect inView:self.view];
    self.searchTableView.searchDelegate = self;
}


- (void)doSearchSuggestionForQuery:(NSString *)query {
    
    [self.searchTableView doSearchSuggestionForQuery:query];
    
}

- (void)onSearchSuggestionRequestFailed {
    
}

- (void)onSearchSuggestionRequestReceived {
    
}

- (void)onSearchSuggestionSelected:(NSString *)query position:(NSInteger)position {
//    NSString *lastQuery = self.searchField.text;
    self.searchField.text = query;
    [self doProductSearchOnQuery:query];
}

#pragma mark -
#pragma mark Search Product helpers and methods
- (void)doProductSearchOnQuery:(NSString *)queryString {
    NSString * trimQuery = [queryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimQuery.length == 0) {
       [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Enter a product information to search.." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else {
        
        [self.searchTableView cancelSearchSuggestionOperation];
        
        
        // Save in recent searches if it is success.
        IXRProductListViewController *productVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productListVC"];
        IXMSearchType *searchType = [self.dropDownItems objectAtIndex:self.selectedDropDownIndexPath];
        productVC.searchtype = searchType;
        productVC.searchQuery = queryString;
        productVC.saveSearchOnSuccess = YES;
        [self.navigationController pushViewController:productVC animated:YES];
        
    }
}


#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // return key pressed
    
    [self doProductSearchOnQuery:textField.text];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString * query = textField.text;
    [self doSearchSuggestionForQuery:query];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    //
    
}

#pragma mark - keyboard
// Call this method somewhere in your view controller setup code.
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
    
    CGRect searchRect = self.searchTableView.frame;
    float height = self.view.frame.size.height - searchRect.origin.y - kbSize.height - 10;
    
    searchRect.size.height = height;
    self.searchTableView.frame = searchRect;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}


@end



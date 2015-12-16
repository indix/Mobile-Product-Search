//
//  IXRSearchSuggestionTableView.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 15/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRSearchSuggestionTableView.h"

@interface IXRSearchSuggestionTableView ()<IXSearchSuggestionHelperDelegate>

@property (nonatomic, strong) IXSearchSuggestionHelper* searchSuggestionHelper;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign, readwrite) BOOL canPerformSearch;

@end


@implementation IXRSearchSuggestionTableView



- (instancetype)initWithFrame:(CGRect)rect inView:(UIView *)view {
    if (self = [super initWithFrame:rect style:UITableViewStyleGrouped]) {
        self.parentView = view;
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = YES;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.searchSuggestionHelper = [[IXSearchSuggestionHelper alloc] init];
        self.searchSuggestionHelper.delegate = self;
        
        self.canPerformSearch = YES;
        [self setHidden:YES];
        
        [self.parentView addSubview:self];
    }
    return self;
}


- (void)cancelSearchSuggestionOperation {
    [self.searchSuggestionHelper cancelSuggestionSearches];
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchSuggestionHelper filteredArrayCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search_suggestion_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search_suggestion_cell"];
    }
    cell.textLabel.text = [self.searchSuggestionHelper filterObjectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDelegate) {
        [self.searchDelegate onSearchSuggestionSelected:[self.searchSuggestionHelper filterObjectAtIndex:indexPath.row] position:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onSearchSuggestionRequestFailed {
    if (_canPerformSearch) {
        if (self.searchDelegate) {
            [self.searchDelegate onSearchSuggestionRequestFailed];
        }
    }
    else {
        NSLog(@"IXRSearchSuggestionTableView: not calling onSearchSuggestionRequestFailed as it is disabled");
    }
    
    
}

- (void)onSearchSuggestionRequestReceived {
    
    if (_canPerformSearch) {
        [self reloadData];
        if ([self.searchSuggestionHelper filteredArrayCount] > 0) {
            [self setHidden:NO];
        }
        else {
            [self setHidden:YES];
        }
        
        if (self.searchDelegate) {
            [self.searchDelegate onSearchSuggestionRequestReceived];
        }
    }
    else {
         NSLog(@"IXRSearchSuggestionTableView: not calling onSearchSuggestionRequestReceived as it is disabled");
    }
    
    
    
}

- (void)doSearchSuggestionForQuery:(NSString *)query {
    if (_canPerformSearch) {
        [self.searchSuggestionHelper doSearchSuggestionForQuery:query];
        [self.searchSuggestionHelper refreshSearchSuggestionOnQuery:query];
        [self reloadData];
        
        
        if ([self.searchSuggestionHelper filteredArrayCount] > 0) {
            [self setHidden:NO];
        }
        else {
            [self setHidden:YES];
        }
    }
    else {
        NSLog(@"IXRSearchSuggestionTableView: cannot call doSearchSuggestionForQuery if canPerformSearch is diabled");
        [self setHidden:YES];
    }
    
    
    
}

- (void)showSearchSuggestionForFurtherSearch:(BOOL)shouldShow {
    _canPerformSearch = shouldShow;
    if (!_canPerformSearch) {
        [self setHidden:YES];
    }
}

@end

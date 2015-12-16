//
//  IXRSearchSuggestionTableView.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 15/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IXSearchSuggestionHelper.h"

@protocol IXRSearchSuggestionTableViewDelegate;

@interface IXRSearchSuggestionTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id <IXRSearchSuggestionTableViewDelegate> searchDelegate;

@property (nonatomic, assign, readonly) BOOL canPerformSearch;

- (instancetype)initWithFrame:(CGRect)rect inView:(UIView *)view;

- (void)doSearchSuggestionForQuery:(NSString *)query;

- (void)showSearchSuggestionForFurtherSearch:(BOOL)shouldShow;

- (void)cancelSearchSuggestionOperation;

@end

@protocol IXRSearchSuggestionTableViewDelegate <NSObject>

@required
- (void)onSearchSuggestionRequestReceived;
- (void)onSearchSuggestionRequestFailed;
- (void)onSearchSuggestionSelected:(NSString *)query position:(NSInteger)position;

@end
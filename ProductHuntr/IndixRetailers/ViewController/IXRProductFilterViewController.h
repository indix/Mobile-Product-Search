//
//  IXRProductFilterViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXMFilterObjects.h"
#import "IXMSelectedFilters.h"
#import "IXMDisplayCategoryFilter.h"

@protocol IXRProductFilterViewControllerDelegate;

@interface IXRProductFilterViewController : UIViewController


@property (nonatomic, strong) IXMFilterObjects *filterObjects;
@property (nonatomic, strong) IXMSelectedFilters *selectedFilters;
@property (nonatomic, strong) NSString *searchQuery;
@property (nonatomic, assign) NSInteger selectedFilterTabIndex;
@property (nonatomic, strong) IXMDisplayCategoryFilter *categoryDisplay;

@property (nonatomic, assign) id<IXRProductFilterViewControllerDelegate> delegate;

@end

@protocol IXRProductFilterViewControllerDelegate <NSObject>

@required
- (void)doFiltersForSelectedFilter:(IXMSelectedFilters *)filters;
- (void)didCancelFilter;
- (void)didAskForClearFilter;
- (void)didSelectedSegmentAtIndex:(NSInteger)index;
- (void)didDownloadAndModifyCategoryDisplay:(IXMDisplayCategoryFilter *)filter;
@end
//
//  IXMCategoryFilterViewTableViewCell.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 05/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXMCategoryFilter.h"

@protocol IXMCategoryFilterViewTableViewCellDelegate;

@interface IXMCategoryFilterViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *minusbutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plusLeftMargin;

@property (nonatomic, strong) IXMCategoryFilter *filter;

@property (nonatomic, assign) id<IXMCategoryFilterViewTableViewCellDelegate> delegate;

@end

@protocol IXMCategoryFilterViewTableViewCellDelegate <NSObject>

- (void)subCategoryRequiredSelected:(IXMCategoryFilter *)filter;
- (void)hideSubCategorySelected:(IXMCategoryFilter *)filter;

@end
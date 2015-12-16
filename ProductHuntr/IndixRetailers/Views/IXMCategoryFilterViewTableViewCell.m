//
//  IXMCategoryFilterViewTableViewCell.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 05/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMCategoryFilterViewTableViewCell.h"

@implementation IXMCategoryFilterViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onPlusButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate subCategoryRequiredSelected:self.filter];
    }
}

- (IBAction)onMinusButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate hideSubCategorySelected:self.filter];
    }
}
@end

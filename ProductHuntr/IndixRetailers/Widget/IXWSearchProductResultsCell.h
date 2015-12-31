//
//  IXProductResultsCell.h
//  IndixDynamo
//
//  Created by Senthil Kumar on 17/06/13.
//  Copyright (c) 2013 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXWSearchProductResultsCell : UITableViewCell

@property (nonatomic) NSString *articleImageURL;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (nonatomic) IBOutlet UILabel *productName;
@property (nonatomic) IBOutlet UILabel *productPrice;
@property (nonatomic) IBOutlet UILabel *availableStores;

- (void)updateTitle:(NSString *)title highlightText:(NSString *)highlight;

@end

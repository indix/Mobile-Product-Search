//
//  IXProductResultsCell.m
//  IndixDynamo
//
//  Created by Senthil Kumar on 17/06/13.
//  Copyright (c) 2013 Indix. All rights reserved.
//

#import "IXProductResultsCell.h"
#import <AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

@interface IXProductResultsCell ()
    @property (nonatomic) AFHTTPRequestOperation *imageOperation;
@end

@implementation IXProductResultsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateTitle:(NSString *)title highlightText:(NSString *)highlight
{
    if (![self.productName respondsToSelector:@selector(attributedText)]) {
        self.productName.text = title;
        return;
    }
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:14.0];
    NSDictionary *attributes = @{NSFontAttributeName: boldFont, NSForegroundColorAttributeName: [UIColor blackColor]};
    self.productName.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)setArticleImageURL:(NSString *)articleImageURL
{
    _articleImageURL = articleImageURL;
    
    if (self.imageOperation) {
        [self.imageOperation cancel];
        self.imageOperation = nil;
    }
    self.imageView.image = nil;
   [self.productImage.layer setBorderColor: [[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2] CGColor]];
   [self.productImage.layer setBorderWidth: 1.0];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_articleImageURL]];
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFImageResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = responseObject;
        self.imageOperation = nil;
        self.productImage.image = image;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.imageOperation = nil;
    }];
    self.imageOperation = op;
    [[NSOperationQueue mainQueue] addOperation:op];
}
 

@end

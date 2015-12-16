//
//  IXImageUrlView.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXImageUrlView.h"
#import <AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

@interface IXImageUrlView ()

@property (nonatomic) AFHTTPRequestOperation *imageOperation;

@end

@implementation IXImageUrlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageURL:(NSString *)articleImageURL
{
    _imageURL = articleImageURL;
    
    if (self.imageOperation) {
        [self.imageOperation cancel];
        self.imageOperation = nil;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_imageURL]];
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFImageResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = responseObject;
        self.imageOperation = nil;
        self.image = image;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.imageOperation = nil;
    }];
    self.imageOperation = op;
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end

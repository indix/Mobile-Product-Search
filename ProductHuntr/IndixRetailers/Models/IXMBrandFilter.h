//
//  IXMBrandFilter.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMBrandFilter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *key; // id

- (instancetype)initWithV2ProductModel:(NSDictionary *)dict;

@end

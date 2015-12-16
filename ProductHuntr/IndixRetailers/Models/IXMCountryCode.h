//
//  IXMCountryCode.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 25/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kIXRCountryCodeUS;
extern NSString * const kIXRCountryCodeIN;

@interface IXMCountryCode : NSObject

/**
 Model to choose country code
 */

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *key;


- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key;

+ (IXMCountryCode *)getCountryCodeForKey:(NSString *)key;
+ (NSArray *)getAllCountryCode;
+ (IXMCountryCode *)getDefaultCountyCode;


@end

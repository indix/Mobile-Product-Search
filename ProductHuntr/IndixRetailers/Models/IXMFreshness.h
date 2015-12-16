//
//  IXMFreshness.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 02/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMFreshness : NSObject

/**
 Models to send freshness information
 */

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NSInteger days;

- (instancetype)initWithKey:(NSInteger)days value:(NSString *)value;


+ (IXMFreshness *)getFreshnessForKey:(NSInteger)key;
+ (NSArray *)getAllFreshness;
+ (IXMFreshness *)getDefaultFreshness;

@end

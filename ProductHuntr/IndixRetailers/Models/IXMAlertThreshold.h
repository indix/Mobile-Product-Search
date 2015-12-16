//
//  IXMAlertThreshold.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMAlertThreshold : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NSInteger percentageAlert;

- (instancetype)initWithKey:(NSInteger)percentageAlert value:(NSString *)value;


+ (IXMAlertThreshold *)getAlertThresholdForKey:(NSInteger)key;
+ (NSArray *)getAllAlertThreshold;
+ (IXMAlertThreshold *)getDefaultAlertThreshold;

@end

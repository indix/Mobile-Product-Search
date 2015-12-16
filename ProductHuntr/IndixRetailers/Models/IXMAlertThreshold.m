//
//  IXMAlertThreshold.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMAlertThreshold.h"

@implementation IXMAlertThreshold

- (instancetype)initWithKey:(NSInteger)percentageAlert value:(NSString *)value {
    if (self = [super init]) {
        self.percentageAlert = percentageAlert;
        self.value = value;
    }
    return self;
}

+ (IXMAlertThreshold *)getAlertThresholdForKey:(NSInteger)key {
    IXMAlertThreshold * thresold = [[IXMAlertThreshold alloc] initWithKey:key value:[NSString stringWithFormat:@"%ld%%", (long)key]];
    return thresold;
}

+ (NSArray *)getAllAlertThreshold {
    return @[[IXMAlertThreshold getAlertThresholdForKey:0], [IXMAlertThreshold getAlertThresholdForKey:5], [IXMAlertThreshold getAlertThresholdForKey:10], [IXMAlertThreshold getAlertThresholdForKey:15], [IXMAlertThreshold getAlertThresholdForKey:20]];
}

+ (IXMAlertThreshold *)getDefaultAlertThreshold {
    return [IXMAlertThreshold getAlertThresholdForKey:0];
}


@end

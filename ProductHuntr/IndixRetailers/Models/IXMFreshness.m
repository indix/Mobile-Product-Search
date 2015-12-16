//
//  IXMFreshness.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 02/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMFreshness.h"

@implementation IXMFreshness

- (instancetype)initWithKey:(NSInteger)days value:(NSString *)value {
    if (self = [super init]) {
        self.days = days;
        self.value = value;
    }
    return self;
}

+ (IXMFreshness *)getFreshnessForKey:(NSInteger)key {
    if (key == 0) {
        IXMFreshness * thresold = [[IXMFreshness alloc] initWithKey:key value:[NSString stringWithFormat:@"None"]];
        return thresold;
    }
    else {
        IXMFreshness * thresold = [[IXMFreshness alloc] initWithKey:key value:[NSString stringWithFormat:@"%ld days", (long)key]];
        return thresold;
    }
    
    
}

+ (NSArray *)getAllFreshness {
    return @[[IXMFreshness getFreshnessForKey:0], [IXMFreshness getFreshnessForKey:7], [IXMFreshness getFreshnessForKey:15], [IXMFreshness getFreshnessForKey:30], [IXMFreshness getFreshnessForKey:60]];
}

+ (IXMFreshness *)getDefaultFreshness {
    return [IXMFreshness getFreshnessForKey:0];
}

@end

//
//  IXMCategoryFilter.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 29/07/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMCategoryFilter.h"

@implementation IXMCategoryFilter

- (instancetype)initWithV2ProductModel:(NSDictionary *)dict  treeIndex:(NSInteger)treeIndex {
    if (self = [super init]) {
        self.key = [[dict objectForKey:@"id"] stringValue];
        self.name = [dict objectForKey:@"name"];
        self.count = [[dict objectForKey:@"count"] stringValue];
        self.treeIndex = treeIndex;
    }
    return self;
}

- (NSString *)displayName {
    
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i=0; i<self.treeIndex; i++) {
        [string appendString:@"    "];
    }
    [string appendString:self.name];
    return string;
}

@end

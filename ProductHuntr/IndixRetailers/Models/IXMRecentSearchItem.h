//
//  IXMRecentSearchItem.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXMRecentSearchItem : NSObject<NSCoding>

/**
 Model to store Recent search item attributes
 */

@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSString *type;


- (instancetype)initWithQuery:(NSString *)query type:(NSString *)type;

+ (NSArray*)all;
+ (void)replaceWithRecentSearch:(NSArray*)allRecentSearchFields;

@end

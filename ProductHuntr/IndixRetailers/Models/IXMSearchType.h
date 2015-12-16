//
//  IXMSearchType.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 18/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kIXRSearchTypeAll;
extern NSString * const kIXRSearchTypeUPC;
extern NSString * const kIXRSearchTypeSKU;
extern NSString * const kIXRSearchTypeMPN;

@interface IXMSearchType : NSObject

/**
 Model to select search type
 */

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *key;


- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key;

// constants
+ (IXMSearchType *)getSearchtypeForKey:(NSString *)key;
+ (NSArray *)getAllSearchTypes;
@end

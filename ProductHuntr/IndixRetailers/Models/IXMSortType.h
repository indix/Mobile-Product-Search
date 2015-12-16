//
//  IXMSortType.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 22/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXMSortType.h"

extern NSString * const kIXRSortTypeRelevance;
extern NSString * const kIXRSortTypeMostRecent;
extern NSString * const kIXRSortTypePriceHighToLow;
extern NSString * const kIXRSortTypePriceLowToHigh;

@interface IXMSortType : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *key;


- (instancetype)initWithTitle:(NSString *)title andKey:(NSString *)key;

+ (IXMSortType *)getSorttypeForKey:(NSString *)key;
+ (NSArray *)getAllSortType;

@end

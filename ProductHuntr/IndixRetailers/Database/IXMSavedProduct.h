//
//  IXMSavedProduct.h
//  ProductHuntr
//
//  Created by Nalin Chhajer on 29/12/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXProduct.h"
#import <CoreData/CoreData.h>

@interface IXMSavedProduct : NSManagedObject

@property (nonatomic, retain) NSString *mpid;
@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *priceRange;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *noOfStores;
@property (nonatomic, retain) NSNumber *createdTime;

@property (nonatomic, retain) NSString *minSalePrice;
@property (nonatomic, retain) NSString *maxSalePrice;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, strong, readonly) NSString *priceRangeLabel;
@property (nonatomic, strong, readonly) NSDate *lastRefreshTimeDate;
@property (nonatomic, retain) NSString *indixVersionType;

@property (nonatomic, retain) NSString *categoryIdPath;
@property (nonatomic, retain) NSString *categoryNamePath;

- (void)copyFromProduct:(IXProduct *)product;
- (IXProduct *)copyOFProduct;

@end

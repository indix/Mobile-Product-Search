//
//  IXMDatabaseManager.h
//  ProductHuntr
//
//  Created by Nalin Chhajer on 04/01/16.
//  Copyright © 2016 Indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "IXMSavedProduct.h"

@interface IXMDatabaseManager : NSObject

+ (instancetype)sharedManager;

- (NSManagedObjectContext *)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (BOOL)saveManagedObjectContext:(NSManagedObjectContext *)context error:(NSError **)error;

- (IXMSavedProduct *)requestCheckIfAddedToFavorites:(IXProduct *)product forManagedContext:(NSManagedObjectContext *)managedObjectContext;

- (void)requestRemoveFromFavorites:(IXMSavedProduct *)saved_product forManagedContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(void))success failure:(void (^)(NSError *error))failure ;

- (void)requestAddToFavorites:(IXProduct *)product forManagedContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(IXMSavedProduct *saved_product))success failure:(void (^)(NSError *error))failure;

@end

//
//  IXMDatabaseManager.m
//  ProductHuntr
//
//  Created by Nalin Chhajer on 04/01/16.
//  Copyright © 2016 Indix. All rights reserved.
//

#import "IXMDatabaseManager.h"
#import "IXRetailerHelperConfig.h"


@interface IXMDatabaseManager ()

@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation IXMDatabaseManager

+ (instancetype)sharedManager
{
    static IXMDatabaseManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IXMDatabaseManager alloc] init];
    });
    return sharedManager;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"IXMSavedProduct" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSString *groupIdentifier = [[IXRetailerHelperConfig instance] groupIdentifier];
        NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupIdentifier];
        NSURL *persistentStoreURL = [groupURL URLByAppendingPathComponent:[[IXRetailerHelperConfig instance] databaseName]];
        
        NSError *pscError = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:persistentStoreURL
                                                             options:@{ NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES}
                                                               error:&pscError]) {
            NSLog(@"Error creating persistent store at %@: %@", persistentStoreURL, [pscError localizedDescription]);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return context;
}

- (BOOL)saveManagedObjectContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSError *saveError = nil;
    BOOL success = [context save:&saveError];
    if (success) {
        
    } else {
        NSLog(@"Core Data save error: %@", [saveError localizedDescription]);
        if (error != nil) {
            *error = saveError;
        }
    }
    return success;
}

- (IXMSavedProduct *)requestCheckIfAddedToFavorites:(IXProduct *)product forManagedContext:(NSManagedObjectContext *)managedObjectContext {
    
    if (product && product.mpid) {
        NSString *mpid = product.mpid;
        return [self fetchSavedProductUsingMPid:mpid forManagedContext:managedObjectContext];
    }
    return nil;
}

- (IXMSavedProduct *)fetchSavedProductUsingMPid:(NSString *)mpid forManagedContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"IXMSavedProduct" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mpid == [c] %@", mpid];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray* searchResults = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (searchResults.count > 0) {
        for (IXMSavedProduct *object in searchResults) {
            if ([mpid isEqualToString:object.mpid]) {
                return object;
            }
        }
    }
    return nil;
}

- (void)requestRemoveFromFavorites:(IXMSavedProduct *)saved_product forManagedContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    if (saved_product.mpid) {
        IXMSavedProduct *product = [self fetchSavedProductUsingMPid:saved_product.mpid forManagedContext:managedObjectContext];
        if (product) {
            [managedObjectContext deleteObject:product];
            NSError *saveError = nil;
            // if added to favorites, delete from managed context.
            if ([self saveManagedObjectContext:managedObjectContext error:&saveError]) {
                success();
            }
            else {
                failure(saveError);
            }
        }
        
    }
    else {
        failure([NSError errorWithDomain:@"INVALID_OBJECT_FOUND" code:200 userInfo:@{@"message":@"cannot reemove object without mpid from favorites."}]);
    }
    
}

- (void)requestAddToFavorites:(IXProduct *)product forManagedContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(IXMSavedProduct *saved_product))success failure:(void (^)(NSError *error))failure {
    if (product.mpid) {
        IXMSavedProduct *check_product = [self fetchSavedProductUsingMPid:product.mpid forManagedContext:managedObjectContext];
        if (check_product) {
            failure([NSError errorWithDomain:@"PRODUCT_ALREADY_IN_FAVORITES" code:200 userInfo:@{@"message":@"product is already been added to favorites."}]);
        }
        else {
            IXMSavedProduct *saved_product = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"IXMSavedProduct"
                                  inManagedObjectContext:managedObjectContext];
            
            [saved_product copyFromProduct:product];
            saved_product.createdTime = [NSNumber numberWithDouble:(double)[[NSDate date] timeIntervalSince1970]];
            NSError *saveError = nil;
            // if added to favorites, delete from managed context.
            if ([self saveManagedObjectContext:managedObjectContext error:&saveError]) {
                success(saved_product);
            }
            else {
                failure(saveError);
            }
        }
    }
    
}

@end

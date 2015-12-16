//
//  IXMRecentSearchItem.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 12/06/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXMRecentSearchItem.h"

@implementation IXMRecentSearchItem

- (instancetype)initWithQuery:(NSString *)query type:(NSString *)type {
    if (self = [super init]) {
        self.query = query;
        self.type = type;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_query forKey:@"query"];
    [encoder encodeObject:_type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *query = [decoder decodeObjectForKey:@"query"];
    NSString * type = [decoder decodeObjectForKey:@"type"];
    return [self initWithQuery:query type:type];
}

+ (void)replaceWithRecentSearch:(NSArray*)allRecentSearchFields
{
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self recentSearchFilePath]]) {
        [fm removeItemAtPath:[self recentSearchFilePath] error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:allRecentSearchFields toFile:[self recentSearchFilePath]];
}

+ (NSString*)recentSearchFilePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* categoriesPath = [documentsDirectory stringByAppendingPathComponent:@"recent_search.plist"];
    return categoriesPath;
}

+ (NSArray*)all
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self recentSearchFilePath]];
}

@end

//
//  IXSearchSuggestionHelper.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 15/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXSearchSuggestionHelper.h"

@interface IXSearchSuggestionHelper ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *searchSuggestionManager;
@property (nonatomic, strong) NSArray *suggestions;
@property (nonatomic, strong) NSArray *filteredArray;

@end

@implementation IXSearchSuggestionHelper

- (instancetype)init {
    if (self = [super init]) {
        
        self.searchSuggestionManager = [IXRetailerHelper getRequestOperationManager];
        self.suggestions = [[NSArray alloc] init];
        self.filteredArray = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)cancelSuggestionSearches {
    [self.searchSuggestionManager.operationQueue  cancelAllOperations];
}

- (void)doSearchSuggestionForQuery:(NSString *)query {
    
    [self cancelSuggestionSearches];
    
    [IXRetailerHelper requestSearchSuggestionForQuery:query withManager:self.searchSuggestionManager success:^(AFHTTPRequestOperation *operation, NSArray *suggestions) {
        
        [self addSearchSuggestion:suggestions forQuery:query];
        
        
        if (self.delegate) {
            [self.delegate onSearchSuggestionRequestReceived];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (![operation isCancelled]) {
            NSLog(@"Search Suggestion failed due to %@",[error localizedDescription]);
            [self.delegate onSearchSuggestionRequestFailed];
        }
        
    }];
}


- (NSInteger) filteredArrayCount {
    return [self.filteredArray count];
}

- (NSString *)filterObjectAtIndex:(NSInteger)index {
    return [self.filteredArray objectAtIndex:index];
}

- (void)refreshSearchSuggestionOnQuery:(NSString *)query {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",query];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.suggestions filteredArrayUsingPredicate:predicate]];
}

#pragma mark - Unit Test

- (void)addSearchSuggestion:(NSArray *)array forQuery:(NSString *)query {
    // or use nsorderset for uniqueness
    
//    NSMutableArray *sArray = [[NSMutableArray alloc] initWithArray:self.suggestions];
//    [sArray addObjectsFromArray:array];
//    
//    self.suggestions = [sArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    self.suggestions = array;
    
    [self refreshSearchSuggestionOnQuery:query];
}


@end

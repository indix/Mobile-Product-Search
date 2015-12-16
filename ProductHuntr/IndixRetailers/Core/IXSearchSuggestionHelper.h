//
//  IXSearchSuggestionHelper.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 15/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXRetailerHelper.h"

@protocol IXSearchSuggestionHelperDelegate;

@interface IXSearchSuggestionHelper : NSObject

- (instancetype)init;

@property (nonatomic, assign) id <IXSearchSuggestionHelperDelegate> delegate;

- (void)doSearchSuggestionForQuery:(NSString *)query;

- (NSInteger) filteredArrayCount;
- (NSString *)filterObjectAtIndex:(NSInteger)index;

- (void)addSearchSuggestion:(NSArray *)array forQuery:(NSString *)query;
- (void)refreshSearchSuggestionOnQuery:(NSString *)query;

- (void)cancelSuggestionSearches;

@end

@protocol IXSearchSuggestionHelperDelegate <NSObject>

@required
- (void)onSearchSuggestionRequestReceived;
- (void)onSearchSuggestionRequestFailed;
@end

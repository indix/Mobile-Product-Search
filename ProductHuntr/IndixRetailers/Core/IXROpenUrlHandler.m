//
//  IXROpenUrlHandler.m
//  ProductHuntr
//
//  Created by Nalin Chhajer on 05/01/16.
//  Copyright © 2016 Indix. All rights reserved.
//

#import "IXROpenUrlHandler.h"
#import "IXRetailerHelperConfig.h"

NSString *const kIXROpenUrlTypeProductDetail = @"product_detail";
NSString *const kIXROpenUrlTypeProductSearch = @"product_search";

@interface IXROpenUrlHandler ()


@end

@implementation IXROpenUrlHandler


- (instancetype)init {
    if (self = [super init]) {
        [self applicationDidBecomeActive];
    }
    return self;
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString *urlScheme = url.scheme;
    NSString *schemeName = [[IXRetailerHelperConfig instance] shareWidgetIdentifier];
    if (urlScheme != nil && [[urlScheme lowercaseString] isEqualToString:schemeName]) {
        // save this url so applicaiton can use it.
        [[NSUserDefaults standardUserDefaults] setObject:[url absoluteString] forKey:@"productHuntrOpenUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PRODUCTHUNTR_DID_RECEIVE_OPEN_URL_CALL" object:url userInfo:nil];
        return YES;
    }
    return NO;
}

- (void)applicationDidBecomeActive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveOpenURLCall:) name:@"PRODUCTHUNTR_DID_RECEIVE_OPEN_URL_CALL" object:nil];
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"productHuntrOpenUrl"];
    if (urlString) {
        NSURL* url = [NSURL URLWithString:urlString];
        [self handleOpenUrlCallForUrl:url];
    }
    
    
}

- (void)handleOpenUrlCallForUrl:(NSURL *)url {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"productHuntrOpenUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *host = url.host;
    if (host == nil) {
        // general
        if (self.delegate) {
            [self.delegate handleOpenUrlOfType:nil parameters:nil];
        }
    }
    else if ([host isEqualToString:kIXROpenUrlTypeProductDetail]) {
        NSString *query = url.query;
        NSDictionary *queryDict = [IXROpenUrlHandler parseQueryForDictionary:query];
        NSLog(@"product detail query is %@", queryDict);
        if (self.delegate) {
            [self.delegate handleOpenUrlOfType:kIXROpenUrlTypeProductDetail parameters:queryDict];
            if (queryDict[@"mpid"]) {
                [self.delegate handleOpenUrlCallOfCaltalogForProduct:queryDict[@"mpid"]];
            }
        }
        
    }
    else if ([host isEqualToString:kIXROpenUrlTypeProductSearch]) {
        NSString *query = url.query;
        NSDictionary *queryDict = [IXROpenUrlHandler parseQueryForDictionary:query];
        NSLog(@"product search query is %@", queryDict);
        if (self.delegate) {
            [self.delegate handleOpenUrlOfType:kIXROpenUrlTypeProductSearch parameters:queryDict];
            if (queryDict[@"q"]) {
                [self.delegate handleOpenUrlCallForSearch:queryDict[@"q"]];
            }
            else {
                [self.delegate handleOpenUrlCallForSearch:@""];
            }
        }
    }
}

- (void)didReceiveOpenURLCall:(NSNotification *)sender {
    NSLog(@"Received open url");
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"productHuntrOpenUrl"];
    if (urlString) {
        NSURL* url = [NSURL URLWithString:urlString];
        [self handleOpenUrlCallForUrl:url];
    }
}

+ (NSDictionary *)parseQueryForDictionary:(NSString *)queryString {
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    if (!queryString) return queryStringDictionary;
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

@end

//
//  IXRProductListViewController.h
//  IndixRetailers
//
//  Created by Nalin Chhajer on 18/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXMSearchType.h"
#import "IXMSortType.h"

@interface IXRProductListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 ViewController that shows list of products based on search. It allows filtering, sorting and shows product in two different types - List/Grid
 */


@property (nonatomic, strong) IXMSearchType *searchtype;
@property (nonatomic, strong) NSString *searchQuery;
@property (nonatomic, assign) BOOL saveSearchOnSuccess;
@property (nonatomic, strong) IXMSortType *sortType; // default is most_recent
@property (nonatomic, strong) UIImage *titleBarImage;


@end

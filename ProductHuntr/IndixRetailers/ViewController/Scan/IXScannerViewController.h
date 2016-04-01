//
//  IXScannerViewController.h
//  IndixPegasus
//
//  Created by Senthil Kumar on 18/07/14.
//  Copyright (c) 2014 Indix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IXScannerViewControllerDelegate;

@interface IXScannerViewController : UIViewController

@property (nonatomic, assign) id <IXScannerViewControllerDelegate> scanDelegate;
@end

@protocol IXScannerViewControllerDelegate <NSObject>

@required
- (void)foundBarCodeWithId:(NSString *)barcodeId;

@end
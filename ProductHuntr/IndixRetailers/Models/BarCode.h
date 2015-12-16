//
//  BarCode.h
//  IndixPegasus
//
//  Created by Senthil Kumar on 18/07/14.
//  Copyright (c) 2014 Indix. All rights reserved.
//


#import <UIKit/UIKit.h>
@import AVFoundation;

@interface Barcode : NSObject

+ (Barcode * )processMetadataObject:(AVMetadataMachineReadableCodeObject*) code;
- (NSString *) getBarcodeType;
- (NSString *) getBarcodeData;
- (void) printBarcodeData;
@end

//
//  IXScannerViewController.m
//  IndixPegasus
//
//  Created by Senthil Kumar on 18/07/14.
//  Copyright (c) 2014 Indix. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "IXScannerViewController.h"
#import "NSString+URLEncoding.h"
#import "MTBBarcodeScanner.h"

@import AVFoundation;   // iOS7 only import style

@interface IXScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableArray *uniqueCodes;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, assign) BOOL didShowCaptureWarning;


@end

@implementation IXScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)goBackToPrev:(id)_id
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self stopRunning];
    [super viewWillDisappear:animated];
    
}


-(void)dismissView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//-(void) allowedBarCodes {
//    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
//    self.allowedBarcodeTypes = [NSMutableArray new];
//    // [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
//    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
//    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
//    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
//}

-(void) setupNotifications {
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startRunning {
    if ([self.scanner isScanning] || self.captureIsFrozen) {
        // Already running
    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
}
- (void)stopRunning {
    [self.scanner stopScanning];
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}


#pragma mark - Delegate functions

- (void) showProducts:(NSString*)barcode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.scanDelegate) {
            [self.scanDelegate foundBarCodeWithId:barcode];
        }
    });
}



#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_previewView];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                
                NSLog(@"Found unique code: %@", code.stringValue);
                [self showProducts:code.stringValue];
            }
        }
    }];
    
}

- (void)stopScanning {
    [self.scanner stopScanning];
    
    self.captureIsFrozen = NO;
}

#pragma mark - Actions

- (void)backTapped {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BarcodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.uniqueCodes[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uniqueCodes.count;
}

#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Scanning Unavailable"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

#pragma mark - Gesture Handlers

- (void)previewTapped {
    if (![self.scanner isScanning] && !self.captureIsFrozen) {
        return;
    }
    
    if (!self.didShowCaptureWarning) {
        [[[UIAlertView alloc] initWithTitle:@"Capture Frozen"
                                    message:@"The capture is now frozen. Tap the preview again to unfreeze."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        
        self.didShowCaptureWarning = YES;
    }
    
    if (self.captureIsFrozen) {
        [self.scanner unfreezeCapture];
    } else {
        [self.scanner freezeCapture];
    }
    
    self.captureIsFrozen = !self.captureIsFrozen;
}

#pragma mark - Setters

- (void)setUniqueCodes:(NSMutableArray *)uniqueCodes {
    _uniqueCodes = uniqueCodes;
}

@end



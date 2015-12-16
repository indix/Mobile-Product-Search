//
//  IXScannerViewController.m
//  IndixPegasus
//
//  Created by Senthil Kumar on 18/07/14.
//  Copyright (c) 2014 Indix. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "IXScannerViewController.h"
#import "Barcode.h"
#import "NSString+URLEncoding.h"

@import AVFoundation;   // iOS7 only import style

@interface IXScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    UIView *_highlightView;
}

@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UILabel *previewLabel;
@property (strong, nonatomic) IBOutlet UIImageView *scannerImageView;

//@property (strong, nonatomic) SettingsViewController * settingsVC;

@end

@implementation IXScannerViewController {
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    _highlightView = [[UIView alloc] initWithFrame:CGRectMake(50,50,200,200)];
    
    //    _highlightView = [[UIView alloc] init];
    //
    //    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    //    _highlightView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _highlightView.layer.borderWidth = 3;
    //    [self.view addSubview:_highlightView];
    
    //self.scannerImageView.layer.borderColor = [UIColor greenColor].CGColor;
    //self.scannerImageView.layer.borderWidth = 3.0;
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    
    // Add the scanner icon to preview screen and bring to front view.
    [_previewView addSubview:self.scannerImageView];
    [_previewView bringSubviewToFront:self.scannerImageView];
    
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    [self setupNotifications];
    [self allowedBarCodes];
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
    [super viewWillDisappear:animated];
    [self stopRunning];
}


-(void)dismissView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) allowedBarCodes {
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    // [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
}

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
#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}


#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    // __block CGRect highlightViewRect = CGRectZero;
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             //              highlightViewRect = code.bounds;
             //               _highlightView.frame = highlightViewRect;
             //                     [self.view bringSubviewToFront:_highlightView];
             
             // [self.view bringSubviewToFront:self.scannerImageView];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    NSLog(@" barcode.. %@",barcode.getBarcodeData);
    [self.foundBarcodes addObject:barcode];
    // [self showBarcodeAlert:barcode];
    [self showProducts:barcode.getBarcodeData];
}

- (void) showProducts:(NSString*)barcode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.scanDelegate) {
            [self.scanDelegate foundBarCodeWithId:barcode];
        }
    });
    
   
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//        IXProductsViewController *svc = [storybord instantiateViewControllerWithIdentifier:@"ProductsViewController"];
//        //svc.title = searchString;
//        
//        // svc.queryType = [NSNumber numberWithInt:UPC_TYPE]; // Search text query.
//        
//        NSString *upc =  [NSString stringWithFormat:@"upc:%@",barcode];
//        NSString *encoded = [upc encodedURLParameterString];
//        NSString *params = [NSString stringWithFormat:@"&q=%@",encoded];
//        
//        svc.selectedData = params;
//        svc.contextString =  params;
//        [svc initalizeDefaultValues];
//        [svc fetchSearchProductLists];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:barcode forKey:@"UPC"];
//            //   [[Mixpanel sharedInstance] track:kBarCodeScan properties:dictionary];
//            
//            // Code to update the UI/send notifications based on the results of the background processing
//            [self.navigationController pushViewController:svc animated:NO];
//            
//        });
//    });
    //    [self.navigationController pushViewController:svc animated:YES];
}
@end



//
//  IXRWhatsNewViewController.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 18/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRWhatsNewViewController.h"
#import "IXRCoreInitializer.h"

@interface IXRWhatsNewViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IXRWhatsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *rtfPath = [[NSBundle mainBundle] URLForResource: @"iXploreWhatNew" withExtension:@"rtf"];
    NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc]   initWithFileURL:rtfPath options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    self.textView.attributedText=attributedStringWithRtf;
    
    [IXRCoreInitializer requestSeenWhatNewControllerForCurrentVersion];
    
    self.title = @"Release Notes";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDonePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

+ (void)showWhatNewViewControllerIfNeeded:(UIViewController *)controller {
    
    if ([IXRCoreInitializer shouldShowWhatNewControllerForCurrentVersion]) {
        [self startWhatNewContoller:controller];
    }
    
    
    
}

+ (void)startWhatNewContoller:(UIViewController *)viewController {
    UINavigationController *navController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"whatNewVC"];
    [viewController presentViewController:navController animated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

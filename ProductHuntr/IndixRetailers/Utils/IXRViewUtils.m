//
//  IXRViewUtils.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 28/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRViewUtils.h"

@implementation IXRViewUtils

+ (void)showThanksYou:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Thank You!!!";
    hud.margin = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

@end

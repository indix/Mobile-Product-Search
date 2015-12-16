//
//  UIColor+Extended.m
//  IndiXetail
//
//  Created by Nalin Chhajer on 23/11/15.
//  Copyright © 2015 Indix. All rights reserved.
//

#import "UIColor+Extended.h"

@implementation UIColor (Extended)

+ (UIColor *)colorFromRGBAString:(NSString *)colorString {

    if(!colorString){
        return nil;
    }

    NSArray *subStrings = [colorString componentsSeparatedByString:@","];
    if(subStrings.count < 4){
        return nil;
    }

    float rString = [[subStrings objectAtIndex:0] floatValue];
    float gString = [[subStrings objectAtIndex:1] floatValue];
    float bString = [[subStrings objectAtIndex:2] floatValue];
    float alphaString = [[subStrings objectAtIndex:3] floatValue];

    return [UIColor colorWithRed:rString/255.0f green:gString/255.0f blue:bString/255.0f alpha:alphaString];
}

@end

//
//  IXRCategorySelectGradientView.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 07/08/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRCategorySelectGradientView.h"

@implementation IXRCategorySelectGradientView

// Change the views layer class to CAGradientLayer class
+ (Class)layerClass
{
    return [CAGradientLayer class];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initGradientLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initGradientLayer];
    }
    return self;
}

// Make custom configuration of your gradient here
- (void)initGradientLayer {
    CAGradientLayer *gLayer = (CAGradientLayer *)self.layer;
    gLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:219.0/255.0 green:66.0/255.0 blue:77.0/255.0 alpha:0.0] CGColor], (id)[[UIColor colorWithRed:219.0/255.0 green:66.0/255.0 blue:77.0/255.0 alpha:1.0] CGColor], nil];
}
@end

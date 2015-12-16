//
//  IXRUtils.m
//  IndixRetailers
//
//  Created by Nalin Chhajer on 19/05/15.
//  Copyright (c) 2015 indix. All rights reserved.
//

#import "IXRUtils.h"

@implementation IXRUtils

+ (NSDictionary *)readPropertiesFrompList:(NSString *)pListPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pListPath ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return properties;
    }
    else {
        NSLog(@"Property list File Not Found!! of name %@",pListPath);
    }
    return nil;
}

+ (NSData *)contentOfFile:(NSString *)name type:(NSString *)type {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:name ofType:type];
    NSData *json = [NSData dataWithContentsOfFile:path];
    return json;
}

+ (NSString *)shortStringForInteger:(NSInteger)value
{
    NSUInteger absValue = ABS(value);
    NSString *shortString;
    
    if (absValue < 1000) {
        shortString = [@(value) stringValue];
    }
    else if (absValue < 100000) {
        shortString = [NSString stringWithFormat:@"%ld,%03lu", (long)value / 1000, (unsigned long)absValue % 1000];
    }
    if(absValue>10000)
        shortString = [NSString stringWithFormat:@"%.1fK", (float)absValue/1000];
    if(absValue>1000000)
        shortString = [NSString stringWithFormat:@"%.1fM", (float)absValue/1000000];
    if(absValue>1000000000)
        shortString = [NSString stringWithFormat:@"%.1fB", (float)absValue/1000000000];
    
    return shortString;
}

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

+ (CGSize)findHeightForAttributedText:(NSAttributedString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

+ (Boolean) isValidEmail: (NSString*) email {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
                                                                           options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* matchesInString = [regex matchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if([matchesInString count]==1)
        return true;
    else
        return false;
}

+ (UIColor *)generateColorAtIndex:(NSInteger)index {
    UIColor *color;
    
    int mask = index % 3;
    switch (mask) {
        case 0:
            color = [UIColor colorWithRed:149.0/255.0 green:117.0/255.0 blue:205.0/255.0 alpha:1.0];
            break;
            
        case 1:
            color = [UIColor colorWithRed:25.0/255.0 green:118.0/255.0 blue:210.0/255.0 alpha:1.0];
            break;
            
        default:
            color = [UIColor colorWithRed:255.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
    }
    
    
    return color;
}

+ (NSString *)getCategoryImage:(NSString *)categoryId {
    if (categoryId) {
        if ([categoryId isEqualToString:@"10181"]) return @"videoGames";
        if ([categoryId isEqualToString:@"10172"]) return @"ToysNGames";
        if ([categoryId isEqualToString:@"10167"]) return @"ToolsNHomeImprovements";
        if ([categoryId isEqualToString:@"10162"]) return @"SportNOutdoor";
        if ([categoryId isEqualToString:@"10182"]) return @"Software";
        if ([categoryId isEqualToString:@"10179"]) return @"shoes";
        if ([categoryId isEqualToString:@"10177"]) return @"PetSupplies";
        if ([categoryId isEqualToString:@"10176"]) return @"PatioLawnNGarden";
        if ([categoryId isEqualToString:@"10165"]) return @"OfficeProducts";
        if ([categoryId isEqualToString:@"10175"]) return @"MusicalInstuments";
        if ([categoryId isEqualToString:@"10169"]) return @"Jewelry";
        if ([categoryId isEqualToString:@"10178"]) return @"IndustrialNScientific";
        if ([categoryId isEqualToString:@"10164"]) return @"HomeNKitchen";
        if ([categoryId isEqualToString:@"10170"]) return @"HealthNPersonalCare";
        if ([categoryId isEqualToString:@"10171"]) return @"GroceryNGourmet";
        if ([categoryId isEqualToString:@"10180"]) return @"Furniture";
        if ([categoryId isEqualToString:@"10168"]) return @"Electronics";
        if ([categoryId isEqualToString:@"16130"]) return @"ComputersNAccesories";
        if ([categoryId isEqualToString:@"16001"]) return @"ClothingNAccersories";
        if ([categoryId isEqualToString:@"10174"]) return @"BabyProducts";
        if ([categoryId isEqualToString:@"10163"]) return @"Automotive";
        if ([categoryId isEqualToString:@"10173"]) return @"ArtsCraftsNSewing";
    }
    return nil;
}



@end

//
//  UIColor.m
//  Protect
//
//  Created by Kiara Robles on 12/24/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *)whiteProColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)blackProColor
{
    return [UIColor blackColor];
}

+ (UIColor *)blueProColor
{
    return [UIColor colorWithRed:98/255.0 green:189/255.0 blue:203/255.0 alpha:1];
}

+ (UIColor *)yellowProColor
{
    return [UIColor colorWithRed:229/255.0 green:161/255.0 blue:0/255.0 alpha:1];
}

+ (UIColor *)redProColor
{
    return [UIColor colorWithRed:208/255.0 green:15/255.0 blue:25/255.0 alpha:1];
}

@end

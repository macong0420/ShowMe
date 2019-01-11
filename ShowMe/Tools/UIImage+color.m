//
//  UIImage+color.m
//  ZongHeng
//
//  Created by 王充 on 15/8/20.
//  Copyright (c) 2015年 李贺. All rights reserved.
//

#import "UIImage+color.h"

@implementation UIImage (color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self convertViewToImageWithSize:CGSizeMake(1, 1) color:color];;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self convertViewToImageWithSize:size color:color];;
}

+ (UIImage*)convertViewToImageWithSize:(CGSize)size color:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end










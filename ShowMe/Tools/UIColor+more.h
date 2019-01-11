//
//  UIColor+more.h
//  ZongHeng
//
//  Created by 李贺 on 15-7-14.
//  Copyright (c) 2015年 李贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (more)

+ (UIColor *)color16WithHexString:(NSString *)color alpha:(float)ap;
+ (UIColor *)colorWithString:(NSString *)colorstr;
+ (UIColor *)color16WithHexString:(NSString *)color;
+ (UIColor *)randomColor;

@end

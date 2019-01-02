//
//  UIBarButtonItem+Common.h
//  ZongHeng
//
//  Created by 李红 on 15/12/22.
//  Copyright © 2015年 李贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)

+ (UIBarButtonItem *)createBarItemWithFrame:(CGRect)frame  Title:(NSString *)title  selector:(SEL)selector target:(id)target;

+ (UIBarButtonItem *)createBarItemWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlImage:(NSString *)highlImage  selector:(SEL)selector target:(id)target;

@end

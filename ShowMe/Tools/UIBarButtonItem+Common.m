//
//  UIBarButtonItem+Common.m
//  ZongHeng
//
//  Created by 李红 on 15/12/22.
//  Copyright © 2015年 李贺. All rights reserved.
//

#import "UIBarButtonItem+Common.h"



@implementation UIBarButtonItem (Common)

+ (UIBarButtonItem *)createBarItemWithFrame:(CGRect)frame  Title:(NSString *)title  selector:(SEL)selector target:(id)target
{
    UIButton *tmpBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBackBtn setFrame:frame];
    [tmpBackBtn setTitle:title forState:UIControlStateNormal];
    [tmpBackBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//    [tmpBackBtn setTitleColor:ZHColor_Background_ffffff_Bff forState:UIControlStateNormal];
//    [tmpBackBtn setTitleColor:ZHColor_E24444 forState:UIControlStateHighlighted];
    [tmpBackBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tmpBtnItem = [[UIBarButtonItem alloc]initWithCustomView:tmpBackBtn];
    return tmpBtnItem;
}

+ (UIBarButtonItem *)createBarItemWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlImage:(NSString *)highlImage  selector:(SEL)selector target:(id)target
{
    UIButton *tmpBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBackBtn setFrame:frame];
    if (normalImage.length) {
        [tmpBackBtn setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    if (highlImage.length) {
        [tmpBackBtn setBackgroundImage:[UIImage imageNamed:highlImage] forState:UIControlStateHighlighted];
    }
    [tmpBackBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tmpBtnItem = [[UIBarButtonItem alloc]initWithCustomView:tmpBackBtn];
    return tmpBtnItem;

}

@end

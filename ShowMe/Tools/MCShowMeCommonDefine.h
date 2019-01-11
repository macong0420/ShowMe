//
//  MCShowMeCommonDefine.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/11.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#ifndef MCShowMeCommonDefine_h
#define MCShowMeCommonDefine_h

#pragma mark - 常用变量

#define ZHSCREEN_BOUNDS     ([UIScreen mainScreen].bounds)
#define ZHSCREEN_Width      ([UIScreen mainScreen].bounds.size.width)
#define ZHSCREEN_Height     ([UIScreen mainScreen].bounds.size.height)
#define ZHSTATUS_H            ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ZHNAVBAR_H             44
#define ZHNAVALL_H             (ZHSTATUS_H + ZHNAVBAR_H)
#define ZHLineHeight        1 / [UIScreen mainScreen].scale
#define WEAKSELF(classObject) __weak __typeof(classObject) weakSelfARC = classObject;
#define ZHVMargin(x) ((x*ZHSCREEN_Height)/(1334/2))
#define ZHHMargin(x) ((x*ZHSCREEN_Width)/(750/2))

#endif /* MCShowMeCommonDefine_h */

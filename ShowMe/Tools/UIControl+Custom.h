//
//  UIControl+Custom.h
//  ZongHeng
//
//  Created by 马聪聪 on 2018/10/22.
//  Copyright © 2018 ZongHeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Custom)

@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔

@end

NS_ASSUME_NONNULL_END

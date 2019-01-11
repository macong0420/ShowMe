//
//  ShowImageViewController.h
//  ShowMe
//
//  Created by 马聪聪 on 2018/12/28.
//  Copyright © 2018 马聪聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowImageViewController : UIViewController
@property (nonatomic, strong) UIImage *img;

- (instancetype)initWithImage:(UIImage *)img;

@end

NS_ASSUME_NONNULL_END

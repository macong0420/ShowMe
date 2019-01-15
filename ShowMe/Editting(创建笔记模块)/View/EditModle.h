//
//  EditModle.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/15.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditModle : NSObject

@property (nonatomic, strong) UIImage *coverImg;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, strong) NSMutableAttributedString *contentText;

- (instancetype)initWithTitle:(NSString *)title Image:(UIImage *)img context:(NSAttributedString *)context;

@end

NS_ASSUME_NONNULL_END

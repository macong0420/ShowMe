//
//  MCEditTopCoverView.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/11.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCEditTopCoverViewDelegate <NSObject>

@optional
- (void)topCoverViewInsertImg;

@end

@interface MCEditTopCoverView : UIView


@property (nonatomic, strong) UIImageView *coverImgView; //封面图片
@property (nonatomic, strong) UIButton *coverAddImgBtn;
@property (nonatomic, weak) id <MCEditTopCoverViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END

//
//  MCEditTopCoverView.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/11.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "MCEditTopCoverView.h"


@interface MCEditTopCoverView ()


@end


@implementation MCEditTopCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
 
    //封面图选择
    _coverImgView = [[UIImageView alloc] init];
    _coverImgView.frame = CGRectMake(0, 0, ZHSCREEN_Width, ZHSCREEN_Width*0.8);
    _coverImgView.backgroundColor = [UIColor color16WithHexString:@"#ECECEC"];
    _coverImgView.userInteractionEnabled = YES;
    [self addSubview:_coverImgView];
    
    _coverAddImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverAddImgBtn.frame = CGRectMake(0, 0, 44, 44);
    _coverAddImgBtn.centerY = ZHSCREEN_Width*0.8*0.5;
    _coverAddImgBtn.centerX = _coverImgView.centerX;
    [_coverAddImgBtn addTarget:self action:@selector(coverAddImgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_coverAddImgBtn setImage:[UIImage imageNamed:@"add-image"] forState:UIControlStateNormal];
    [_coverImgView addSubview:_coverAddImgBtn];
}

- (void)coverAddImgBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(topCoverViewInsertImg)]) {
        [_delegate topCoverViewInsertImg];
    }
}

@end

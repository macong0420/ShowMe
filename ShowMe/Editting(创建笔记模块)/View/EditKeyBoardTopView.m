//
//  EditKeyBoardTopView.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/15.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "EditKeyBoardTopView.h"

@implementation EditKeyBoardTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = 40;
        self.width = ZHSCREEN_Width;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0, ZHSCREEN_Width, 0.5);
        lineView.backgroundColor = [UIColor color16WithHexString:@"#ECECEC"];
        [self addSubview:lineView];
        
        NSArray *leftArray = @[@"字体",@"居中",@"图片"];
        for (int i = 0; i < leftArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000 + i;
            [btn setImage:[UIImage imageNamed:leftArray[i]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(10 + i * (40 + 5), 0, 40, 40);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        NSArray *rightArray = @[@"author_key",@"save"];
        for (int i = 0; i < rightArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 2000 + i;
            [btn setImage:[UIImage imageNamed:rightArray[i]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(ZHSCREEN_Width - (10 + (i+1) * (40 + 5)), 0, 40, 40);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

#pragma -mark 事件
-(void)btnClick:(UIButton*)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(editdidClick:button:)]) {
        [_delegate editdidClick:self button:btn];
    }
}

@end

//
//  EditInputView.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/14.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "EditInputView.h"


@interface EditInputView ()


@end

@implementation EditInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    //标题
    _titleField = [[UITextField alloc] init];
    _titleField.placeholder = @"Title";
    _titleField.font = [UIFont boldSystemFontOfSize:24];
    _titleField.textAlignment = NSTextAlignmentCenter;
    _titleField.frame = CGRectMake(20, 0, ZHSCREEN_Width-40, 30);
    [self addSubview:_titleField];
    
    _inputView = [[YYTextView alloc] init];
    _inputView.frame = CGRectMake(0, _titleField.bottom + 50, ZHSCREEN_Width, ZHSCREEN_Height -ZHSCREEN_Width*0.8);
    _inputView.placeholderText = @"愿这个世界  温柔以待";
    _inputView.backgroundColor = [UIColor whiteColor];
//    _inputView.typingAttributes = attributes;
//    _inputView.delegate = self;
    _inputView.textAlignment = NSTextAlignmentLeft;
    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.textContainerInset = UIEdgeInsetsMake(30, 10, 64, 10);
    [self addSubview:_inputView];
}


@end

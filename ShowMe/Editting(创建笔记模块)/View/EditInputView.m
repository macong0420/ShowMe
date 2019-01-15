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
    _titleField.frame = CGRectMake(20, 20, ZHSCREEN_Width-40, 30);
    _titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:_titleField];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:20],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    _inputView = [[YYTextView alloc] init];
    _inputView.frame = CGRectMake(0, _titleField.bottom + 15, ZHSCREEN_Width, ZHSCREEN_Height -_titleField.height-ZHNAVALL_H);
    _inputView.placeholderText = @"愿这个世界  温柔以待";
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.typingAttributes = attributes;
    _inputView.textAlignment = NSTextAlignmentLeft;
    _inputView.font = [UIFont systemFontOfSize:18];
    _inputView.textContainerInset = UIEdgeInsetsMake(0, 10, 64, 10);
    [self addSubview:_inputView];
}


@end

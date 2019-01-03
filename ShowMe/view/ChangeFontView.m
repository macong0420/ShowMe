//
//  ChangeFontView.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/3.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "ChangeFontView.h"

@implementation ChangeFontView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    NSArray *arrayTitle = @[@"系统字体",@"",@"",@"",@"",@""];
    NSArray *arrayImage = @[@"",@"可可童话体",@"默默谁想体",@"h-gongshu",@"pangzhonghuaxingshu",@"瘦金体"];

}

@end

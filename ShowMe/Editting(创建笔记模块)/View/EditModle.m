//
//  EditModle.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/15.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "EditModle.h"

@implementation EditModle

- (instancetype)initWithTitle:(NSString *)title Image:(UIImage *)img context:(NSAttributedString *)context {
    if (self = [super init]) {
        _coverImg = img;
        _title = title;
        _contentText = context;
    }
    return self;
}

@end

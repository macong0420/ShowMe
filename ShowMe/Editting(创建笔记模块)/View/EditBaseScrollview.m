//
//  EditBaseScrollview.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/14.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "EditBaseScrollview.h"

@implementation EditBaseScrollview


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [_underButton convertPoint:point fromView:self];
    if ([_underButton pointInside:buttonPoint withEvent:event]) {
        return _underButton;
    }
    return result;
}


@end

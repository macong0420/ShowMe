//
//  UILabel+StringFrame.h
//  ZongHeng
//
//  Created by 王充 on 15/9/16.
//  Copyright (c) 2015年 李贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
- (CGSize)boundingRectWithSize:(CGSize)size;
- (void)setInformationText:(NSInteger)integer;
- (void)setLineSpacing:(CGFloat)lineSpacing  WithlabelContent:(NSString *)labelContent;
- (void)setLineSpacing:(CGFloat)lineSpacing  WithAttributedStringLabelContent:(NSAttributedString *)labelContent;

- (void)setfirstLineHeadIndent:(CGFloat)firstLineHeadIndent  LineSpacing:(CGFloat)lineSpacing labelContent:(NSString *)labelContent;
@end

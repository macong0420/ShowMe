//
//  UILabel+Common.h
//  PandaReader
//
//  Created by 李红 on 16/5/13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)


+ (UILabel *)craeteLabelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(float)fontSize;
+ (UILabel *)craeteLabelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(float)fontSize bold:(BOOL)bold;

//两端对齐
- (void)textAlignmentLeftAndRight;
//指定Label以最后的冒号对齐的width两端对齐
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;

+ (UILabel *)labelWithSize:(CGSize)size  Title:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)color;

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize;

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment;


/// 通用计算 label 高度和设置 label 行间距方法

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

/// 荐语计算 label 高度和设置 label 行间距方法 荐语中的NSAttributedString添加了图片 需要特殊处理

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing attachImage:(NSString *)attchImageName;

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing attachImage:(NSString *)attchImageName;

- (void)setAtributeStrWithString:(NSString *)str;

@end

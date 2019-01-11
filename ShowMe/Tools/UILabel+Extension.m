//
//  UILabel+StringFrame.m
//  ZongHeng
//
//  Created by 王充 on 15/9/16.
//  Copyright (c) 2015年 李贺. All rights reserved.
//

#import "UILabel+Extension.h"
#import "UIColor+more.h"


@implementation UILabel (Extension)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
- (void)setInformationText:(NSInteger)integer{
    if (integer <1) {
        self.text = @"0";
        [self setTextColor:[UIColor color16WithHexString:@"#E24444"]];
        return;
    }
    self.text = [NSString stringWithFormat:@"%zd",integer];
    [self setTextColor:[UIColor color16WithHexString:@"#E24444"]];
}

- (void)setLineSpacing:(CGFloat)lineSpacing  WithlabelContent:(NSString *)labelContent{
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString :labelContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelContent length])];
    self.attributedText = attributedString;
    //[self sizeToFit];
    
}

- (void)setLineSpacing:(CGFloat)lineSpacing  WithAttributedStringLabelContent:(NSAttributedString *)labelContent{
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithAttributedString:labelContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelContent length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

- (void)setfirstLineHeadIndent:(CGFloat)firstLineHeadIndent LineSpacing:(CGFloat)lineSpacing labelContent:(NSString *)labelContent{
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy] ;
    [style setLineSpacing:lineSpacing];
    style.alignment = NSTextAlignmentLeft;  //对齐
    //style.headIndent = 100;          //行首缩进
    style.firstLineHeadIndent = firstLineHeadIndent;//首行缩进
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:labelContent attributes:@{ NSParagraphStyleAttributeName : style}];
    self.attributedText = attrText;
    [self sizeToFit];
}
@end

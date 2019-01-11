//
//  UILabel+Common.m
//  PandaReader
//
//  Created by 李红 on 16/5/13.
//
//

#import "UILabel+Common.h"


@implementation UILabel (Common)


+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = titleColor;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = titleColor;
    label.text = title;
    label.textAlignment = textAlignment;
    
    return label;
}


- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}


+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    CGFloat tempHeight = 0;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    tempHeight = label.height;
    if (tempHeight < fontSize*2) { //一行
        tempHeight = fontSize;
    }
    return tempHeight;
}

#pragma makr - 荐语 专用
/*
 *  因图片和文字混合的地方,目前只有这一个地方用到,单独处理荐语label 的高度计算和行间距设置,上方的方法比较通用 不修改上面方法 在这单独开两个专门使用的方法
 */

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing attachImage:(NSString *)attchImageName {
    CGFloat tempHeight = 0;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing attachImage:attchImageName];
    [label sizeToFit];
    tempHeight = label.height;
    if (tempHeight < fontSize*2) { //一行
        tempHeight = fontSize;
    }
    return tempHeight;
}

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing attachImage:(NSString *)attchImageName {
    
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:attchImageName];
    attch.bounds = CGRectMake(0, -2.5, attch.image.size.width, attch.image.size.height); //-2.5 图片的高度比文字高度达 使用负值 图片和文字上下居中
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attch)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    [attributedString insertAttributedString:string atIndex:0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

+ (UILabel *)craeteLabelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(float)fontSize {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (UILabel *)craeteLabelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(float)fontSize bold:(BOOL)bold {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    if (bold) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return label;
}

//两端对齐
- (void)textAlignmentLeftAndRight {
    [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.frame)];
}
//指定Label以最后的冒号对齐的width两端对齐
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth {
    
    if(self.text==nil||self.text.length==0) {
        return;
    }
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    NSInteger length = (self.text.length-1);
    NSString* lastStr = [self.text substringWithRange:NSMakeRange(self.text.length-1,1)];
    if([lastStr isEqualToString:@":"]||[lastStr isEqualToString:@"："]) {
        length = (self.text.length-2);
    }
    CGFloat margin = (labelWidth - size.width)/length;
    NSNumber*number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    self.attributedText = attribute;
}

//---------作者中心使用------ 设置不同字体颜色,加粗
- (void)setAtributeStrWithString:(NSString *)str {
    
    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                NSForegroundColorAttributeName:[UIColor color16WithHexString:@"#FF832F"],
                                };
    
    NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName:[UIColor color16WithHexString:@"#2D2035"],
                                };
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length-1);
    NSRange range1 = NSMakeRange(str.length-1, 1);
    
    [attrStr addAttributes:dictAttr0 range:range];
    [attrStr addAttributes:dictAttr1 range:range1];
    self.attributedText = attrStr;
//    label.attributedText = attrStr;
}

@end

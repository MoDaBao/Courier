//
//  UILabel+LabelHeightAndWidth.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UILabel+LabelHeightAndWidth.h"

@implementation UILabel (LabelHeightAndWidth)

//  根据宽度获取高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
//    label.text = title;
//    label.font = font;
//    label.numberOfLines = 0;
//    [label sizeToFit];
//    return label.frame.size.height;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

//  根据文字获取宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

//  获取文字个数
+ (NSInteger)getWordCountWithTitle:(NSString *)title font:(UIFont *)font {
    NSInteger singleWidth = [UILabel getWidthWithTitle:@"卧" font:font];
    NSInteger textWidht = [UILabel getWidthWithTitle:title font:font];
    NSInteger count = textWidht / singleWidth;
//    self.wordCount.text = [NSString stringWithFormat:@"%ld",_count - count];
//    // 把textView的文本内容传回视图控制器
//    self.passValue(self.textView.text, count);
    return count;
}

//  获取文字高度
+ (CGFloat)getHeightWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.height;
}

@end

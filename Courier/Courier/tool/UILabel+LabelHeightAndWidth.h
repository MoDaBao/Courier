//
//  UILabel+LabelHeightAndWidth.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeightAndWidth)

//  根据宽度获取高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

//  根据高度获取宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

//  获取文字个数
+ (NSInteger)getWordCountWithTitle:(NSString *)title font:(UIFont *)font;

//  获取文字高度
+ (CGFloat)getHeightWithTitle:(NSString *)title font:(UIFont *)font;

@end

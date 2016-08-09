//
//  MOTextField.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOTextField : UIView

@property (nonatomic, strong) UITextField *textField;


- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder lineColor:(UIColor *)lineColor font:(UIFont *)font;

@end

//
//  MOTextField.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MOTextField.h"


@implementation MOTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder lineColor:(UIColor *)lineColor font:(UIFont *)font {
    if (self = [super initWithFrame:frame]) {
        
        // textfield与view的间距
        CGFloat margin = 15;
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, self.width - margin * 2, self.height)];
        self.textField.placeholder = placeholder;
        self.textField.tintColor = lineColor;// 修改光标颜色
        self.textField.font = font;
        [self addSubview:self.textField];
//        self.textField.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height -  1, self.width, 1)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
    }
    return self;
    
    
}



@end

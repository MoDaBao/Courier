//
//  MessageBarButton.m
//  Courier
//
//  Created by 莫大宝 on 16/7/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MessageBarButton.h"

@interface MessageBarButton ()
@property (nonatomic, copy) NSString *title;
@end

@implementation MessageBarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font {
    if (self = [super initWithFrame:frame]) {
        _title = title;
        CGFloat titleW = [UILabel getWidthWithTitle:title font:font];
        CGFloat titleH = [UILabel getHeightWithTitle:title font:font];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - titleH, titleW, titleH)];
        titleLabel.text = title;
        titleLabel.font = font;
        [self addSubview:titleLabel];
        
        CGFloat markW = 10;
        CGFloat markH = 10;
        self.oneMark = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - markW, 0, markW, markH)];
        self.oneMark.image = [UIImage imageNamed:@"one"];
        [self addSubview:self.oneMark];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

- (void)clickBtn {
    if (self.click) {
        self.click(); 
    }
//    self.click();
    if ([_title isEqualToString:@"消息"]) {
        if ([self.delegate respondsToSelector:@selector(messageBarButtonChat)]) {
            [self.delegate messageBarButtonChat];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(messageBarButtonNav)]) {
            [self.delegate messageBarButtonNav];
        }
    }
    
    
    
    
}

@end

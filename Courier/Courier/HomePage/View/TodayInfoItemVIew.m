//
//  TodayInfoItemVIew.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TodayInfoItemVIew.h"

@implementation TodayInfoItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor orangeColor];
        CGFloat centerY = frame.size.height * .5;
        UIFont *font = [UIFont systemFontOfSize:16];
        CGFloat height = [UILabel getHeightWithTitle:title font:font] + 6;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY - height, frame.size.width, height)];
        titleLabel.numberOfLines = 2;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = font;
//        titleLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:titleLabel];
        
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY, frame.size.width, height)];
        self.valueLabel.font = font;
//        self.valueLabel.backgroundColor = [UIColor redColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.text = value;
        [self addSubview:self.valueLabel];
        
    }
    return self;
}

@end

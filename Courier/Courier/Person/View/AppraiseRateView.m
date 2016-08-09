
//
//  AppraiseRateView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AppraiseRateView.h"
#import "ClearView.h"

@interface AppraiseRateView ()

@property (nonatomic, strong) UIView *clearView;// 镂空视图

@property (nonatomic, assign) CGFloat goodRate;// 好评率

@end

@implementation AppraiseRateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat margin = 20;
    CGFloat radius = 19;
    
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctf, radius * 2);
    CGContextMoveToPoint(ctf, margin, self.height * .5);
    CGContextAddLineToPoint(ctf, (self.width - margin) * self.goodRate, self.height * .5);
    [[UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00] set];
    CGContextStrokePath(ctf);
    
    
    
}


- (instancetype)initWithFrame:(CGRect)frame goodRate:(CGFloat)goodRate title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00];
        
        self.clearView = [[ClearView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.clearView];
        
        self.goodRate = goodRate;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat margin = 20;
        
        CGFloat titleWidth = [UILabel getWidthWithTitle:title font:font];
        CGFloat titleHeight = [UILabel getHeightWithTitle:title font:font];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.font = font;
        titleLabel.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
        titleLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
        titleLabel.frame = CGRectMake((self.width - titleWidth) * .5, 0, titleWidth + 10, titleHeight);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, titleHeight * .5, self.width - margin * 2, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
        
        [self addSubview:line];
        [self addSubview:titleLabel];
        
        NSString *rateStr = [NSString stringWithFormat:@"好评率%%%02.0f",goodRate * 100];
        NSInteger length = [rateStr length];
        UIFont *attFont = [UIFont systemFontOfSize:13];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:rateStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, length - 3)];// length - 3 = rateStr字符串总长度 - 百分比字符串的长度
        [attStr addAttribute:NSForegroundColorAttributeName value:titleLabel.textColor range:NSMakeRange(0, length - 3)];
        
        CGFloat rateWidth = [UILabel getWidthWithTitle:rateStr font:attFont];
        CGFloat rateHeight = [UILabel getHeightWithTitle:rateStr font:attFont];
        UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - rateWidth) * .5, titleLabel.y + titleLabel.height + 10 * kScaleForHeight, rateWidth, rateHeight)];
        rateLabel.attributedText = attStr;
        rateLabel.font = attFont;
        [self addSubview:rateLabel];
        
        
        
        
    }
    return self;
}

@end

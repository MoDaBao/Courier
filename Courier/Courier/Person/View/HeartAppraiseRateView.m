//
//  HeartAppraiseRateView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "HeartAppraiseRateView.h"
#define kScale

@interface HeartAppraiseRateView ()

@property (nonatomic, assign) CGFloat goodRate;

@end

@implementation HeartAppraiseRateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat margin = 28 * (24 / 200.0);// 28是原始爱心图片左右两侧白条的距离 | 24 / 200.0是当前图片的宽度 / 图片原始宽度 | 两数相乘为当前大小下的爱心图片左右两侧白条的距离
    
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctf, kHeartHeight);
    [[UIColor redColor] set];
    CGContextMoveToPoint(ctf, 0, kHeartHeight * .5);
    NSInteger goodRate = self.goodRate * 100;
    CGFloat heartCount = goodRate / 20;// 显示几颗爱心
    CGFloat hearRemainder = (goodRate % 20) / 100.0 / 0.2;
    CGContextAddLineToPoint(ctf, heartCount * kHeartWidth + margin + (kHeartWidth - margin * 2) * hearRemainder, kHeartHeight * .5);
    CGContextStrokePath(ctf);
    
}


- (instancetype)initWithFrame:(CGRect)frame goodRate:(CGFloat)goodRate {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.66 green:0.71 blue:0.71 alpha:1.00];
        CGFloat width = kHeartWidth;
        CGFloat height = kHeartHeight;
        for (NSInteger i = 0; i < 5; i ++) {
            UIImageView *heartView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            heartView.image = [UIImage imageNamed:@"heart"];
            [self addSubview:heartView];
        }
        self.goodRate = goodRate;
        
    }
    return self;
}

@end

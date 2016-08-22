//
//  ClearView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/21.
//  Copyright © 2016年 dabao. All rights reserved.
//  镂空视图

#import "ClearView.h"

@implementation ClearView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.margin = 20;
    CGFloat radius = 12 * kScaleForHeight;
    
    //中间镂空的矩形框
    CGRect myRect = CGRectMake(self.margin, self.height * .5 - radius, self.width - self.margin * 2, radius * 2);
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:myRect.size.height * .5];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00].CGColor;
    fillLayer.opacity = 1.0;
    [self.layer addSublayer:fillLayer];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end

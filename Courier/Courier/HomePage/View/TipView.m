//
//  TipView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/16.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TipView.h"

@implementation TipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 全屏阴影遮罩
        UIView *shade = [[UIView alloc] initWithFrame:frame];
        shade.backgroundColor = [UIColor blackColor];
        shade.alpha = .0;
        [shade setTag:2222];
        [self addSubview:shade];
        
        // 白色背景
        CGFloat whiteX = kScreenWidth * .2;
        CGFloat whiteY = kScreenHeight / 3;
        CGFloat whiteW = kScreenWidth - kScreenWidth * .2 * 2;
        CGFloat whiteH = whiteW * (5.0 / 9);
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(whiteX, whiteY, whiteW, whiteH)];
        whiteView.layer.cornerRadius = 5;
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.alpha = .0;
        [whiteView setTag:1111];
        [self addSubview:whiteView];
        
        // 提示部分
        CGFloat tipMargin = 15;
        UIFont *tipFont = [UIFont systemFontOfSize:14];
        NSString *title = @"温馨提示";
        CGFloat titleW = [UILabel getWidthWithTitle:title font:[UIFont systemFontOfSize:14]];
        CGFloat titleH = [UILabel getHeightByWidth:titleW title:title font:tipFont];
        CGFloat titleX = (whiteW - titleW) * .5;
        UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, tipMargin, titleW, titleH)];
        tipTitleLabel.text = title;
        tipTitleLabel.font = tipFont;
        [whiteView addSubview:tipTitleLabel];
        
        NSString *tip = @"有新订单了，立刻去抢单！";
        CGFloat tipW = [UILabel getWidthWithTitle:tip font:tipFont];
        CGFloat tipX = (whiteW - tipW) * .5;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipX, tipTitleLabel.y + titleH + tipMargin, tipW, titleH)];
        tipLabel.text = tip;
        tipLabel.font = tipFont;
        [whiteView addSubview:tipLabel];
        
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, whiteH / 3.0 * 2, whiteW, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00];
        [whiteView addSubview:line];
        
        // 按钮部分
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        orderBtn.frame = CGRectMake(0, line.y, whiteView.width, whiteH / 3.0);
        [orderBtn setTitle:@"前去抢单" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:orderBtn];
        
        
        [UIView animateWithDuration:.3 animations:^{
            shade.alpha = .5;
            whiteView.alpha = 1.0;
        }];
        
    }
    return self;
}

- (void)order {
    UIView *shade = [self viewWithTag:2222];
    UIView *whiteView = [self viewWithTag:1111];
    [UIView animateWithDuration:.3 animations:^{
        shade.alpha = 0.0;
        whiteView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end

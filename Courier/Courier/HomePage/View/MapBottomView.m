//
//  MapBottomView.m
//  Courier
//
//  Created by 莫大宝 on 16/7/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MapBottomView.h"

@implementation MapBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    CGFloat height = 110;
    self.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
}


@end

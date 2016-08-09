//
//  CallOutCourierTableViewCell.m
//  Courier
//
//  Created by 莫大宝 on 16/7/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CallOutCourierTableViewCell.h"

@implementation CallOutCourierTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置接单按钮的圆角效果和阴影效果
    self.orderReceivingBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.orderReceivingBtn.layer.cornerRadius = self.orderReceivingBtn.height * 0.45;// 设置圆角效果
    self.orderReceivingBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.orderReceivingBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.orderReceivingBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.orderReceivingBtn.layer.shadowRadius = 4;// 阴影半径
    
    // 设置内容试图的边框和圆角效果
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.borderWidth = 1;
    self.contentV.layer.borderColor = [UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00].CGColor;
    
    [self.orderReceivingBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView removeFromSuperview];
}

- (void)btnClick {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

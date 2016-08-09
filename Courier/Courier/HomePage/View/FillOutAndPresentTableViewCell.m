//
//  FillOutAndPresentTableViewCell.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/17.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "FillOutAndPresentTableViewCell.h"

@implementation FillOutAndPresentTableViewCell

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
    
    // 设置订单类型标签的圆角和颜色
    self.orderTypeLabel.layer.cornerRadius = 3;
    self.orderTypeLabel.clipsToBounds = YES;
    self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:211 / 255.0f green:47 / 255.0f blue:47 / 255.0f alpha:1.0];
    
    // 设置支付状态标签的圆角和颜色
    self.payStatusLabel.layer.cornerRadius = 3;
    self.payStatusLabel.clipsToBounds = YES;
    self.payStatusLabel.backgroundColor = [UIColor colorWithRed:239 / 255.0f green:83 / 255.0f blue:80 / 255.0f alpha:1.0];
//    [UIColor colorWithRed:0.93 green:0.33 blue:0.33 alpha:1.00];
    
    // 设置支付方式标签的圆角和颜色
    self.paymentLabel.layer.cornerRadius = 3;
    self.paymentLabel.clipsToBounds = YES;
    self.paymentLabel.backgroundColor = [UIColor colorWithRed:242 / 255.0f green:156 / 255.0f blue:159 / 255.0f alpha:1.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NeedWriteOrderTableViewCell.m
//  Courier
//
//  Created by 莫大宝 on 16/6/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NeedWriteOrderTableViewCell.h"
#import "WriteInfoViewController.h"

@implementation NeedWriteOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置接单按钮的圆角效果和阴影效果
    self.writeBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.writeBtn.layer.cornerRadius = self.writeBtn.height * 0.45;// 设置圆角效果
    self.writeBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.writeBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.writeBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.writeBtn.layer.shadowRadius = 4;// 阴影半径
    
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
    
    // 设置需填单标签的圆角和颜色
    self.needWriteLabel.layer.cornerRadius = 3;
    self.needWriteLabel.clipsToBounds = YES;
    self.needWriteLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:190 / 255.0f blue:231 / 255.0f alpha:1.0];
    
    // 设置编号标签的圆角效果
    self.numberLabel.layer.cornerRadius = self.numberLabel.height * .5f;
    self.numberLabel.clipsToBounds = YES;
    
    [self.writeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    self.click();
}

- (void)setDataWithMolde:(BaseModel *)model {
    // 订单类型
    if (model.type.intValue == 1) {
        self.orderTypeLabel.text = @"帮我拿";
    } else if (model.type.intValue == 2) {
        self.orderTypeLabel.text = @"帮我送";
    } else {
        self.orderTypeLabel.text = @"帮我买";
    }
    
    // 支付状态
    if (!model.pay_status.boolValue) {
        self.payStatusLabel.text = @"未支付";
    } else {
        self.payStatusLabel.text = @"已支付";
    }
    
    self.orderNumberLabel.text = model.order_sn;// 订单编号
    self.timeLabel.text = model.created;
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

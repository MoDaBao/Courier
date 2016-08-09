	//
//  CheckingTableViewCell.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CheckingTableViewCell.h"

@implementation CheckingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置编号标签的圆角效果
    self.numberLabel.layer.cornerRadius = self.numberLabel.height * .5f;
    self.numberLabel.clipsToBounds = YES;
    
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
    
    // 设置距离标签
    self.distanceLabel.layer.cornerRadius = 3;
    self.distanceLabel.clipsToBounds = YES;
    self.distanceLabel.backgroundColor = [UIColor colorWithRed:244 / 255.0f green:143 / 255.0f blue:177 / 255.0f alpha:1.0];
    
    // 设置配送状态标签
    self.deliveryStatusLabel.layer.cornerRadius = 3;
    self.deliveryStatusLabel.clipsToBounds = YES;
    self.deliveryStatusLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:190 / 255.0f blue:231 / 255.0f alpha:1.0];
    
    // 设置圈圈审核标签的效果
    self.checkLabel.layer.cornerRadius = self.checkLabel.height * .5f;
    self.checkLabel.layer.borderColor = self.checkLabel.textColor.CGColor;
    self.checkLabel.layer.borderWidth = 2;
    self.checkLabel.clipsToBounds = YES;
    [self bringSubviewToFront:self.checkLabel];
}

- (void)setDataWithModel:(BaseModel *)model {
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
    // 支付方式
    if (model.payment.intValue == 1) {
        self.paymentLabel.text = @"支付宝";
    } else if (model.payment.intValue == 2) {
        self.paymentLabel.text = @"微信";
    } else if (model.payment.intValue == 3) {
        self.paymentLabel.text = @"银联";
    } else {
        self.paymentLabel.text = @"货到付款";
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"距%.2fkm",model.distance.floatValue / 1000.0];// 距离
    self.orderNumberLabel.text = model.order_sn;// 订单号
    self.timeLabel.text = model.created;// 下单时间
    self.startLabel.text = model.start;// 起始地址
    self.endLabel.text = model.end;// 收货地址
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

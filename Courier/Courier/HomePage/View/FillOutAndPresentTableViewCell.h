//
//  FillOutAndPresentTableViewCell.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/17.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillOutAndPresentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;// 订单类型

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;// 支付方式

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间

@property (weak, nonatomic) IBOutlet UILabel *startLabel;// 起始地点

@property (weak, nonatomic) IBOutlet UILabel *endLabel;// 收货地点

@property (weak, nonatomic) IBOutlet UIButton *orderReceivingBtn;// 接单按钮
@end
//
//  CheckingDefaultTableViewCell.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface CheckingDefaultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;// 编号

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;// 订单类型

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;// 支付方式

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;// 距离

@property (weak, nonatomic) IBOutlet UILabel *deliveryStatusLabel;// 配送状态

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间

@property (weak, nonatomic) IBOutlet UIButton *exclamationBtn;// 叹号按钮

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;//审核中标签

- (void)setDataWithModel:(BaseModel *)model;


@end

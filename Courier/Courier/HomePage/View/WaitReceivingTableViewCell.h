//
//  WaitReceivingTableViewCell.h
//  Courier
//
//  Created by 莫大宝 on 16/8/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

typedef void (^ClickBlock)(void);
typedef void(^OrderReceivingBlock)(NSString *);

@interface WaitReceivingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图


@property (weak, nonatomic) IBOutlet UIImageView *orderTypeimage;// 订单类型

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;// 支付方式

//@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;// 距离
//
//@property (weak, nonatomic) IBOutlet UILabel *deliveryStatusLabel;// 配送状态

//@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号

@property (weak, nonatomic) IBOutlet UILabel *expectedTime;// 预计送达


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间

@property (weak, nonatomic) IBOutlet UILabel *startLabel;// 起始地点

@property (weak, nonatomic) IBOutlet UILabel *endLabel;// 收货地点

@property (weak, nonatomic) IBOutlet UIButton *pickBtn;// 接单按钮

@property (nonatomic, copy) ClickBlock click;// 接单按钮
@property (nonatomic, copy) OrderReceivingBlock orderRcceiving;

- (void)setDataWithModel:(BaseModel *)model;

@end

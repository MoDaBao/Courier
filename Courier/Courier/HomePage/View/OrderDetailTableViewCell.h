//
//  OrderDetailTableViewCell.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/17.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

typedef void(^PushMapView)(void);

typedef void(^RequestBlock)(void);

@protocol OrderDetailTableViewCellDelegate <NSObject>

- (void)orderRefreshWithMessage:(NSString *)message status:(NSString *)status;

@end



@interface OrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容视图
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;// 编号
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;// 订单类型
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;// 支付方式
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;// 距离
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;// 审核
@property (weak, nonatomic) IBOutlet UILabel *startLabel;// 起始地点
@property (weak, nonatomic) IBOutlet UILabel *endLabel;// 终点
@property (weak, nonatomic) IBOutlet UILabel *courierPhoneLabel;// 送货电话
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;// 收货电话
@property (weak, nonatomic) IBOutlet UILabel *distancePriceLabel;// 跑腿费
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;// 物品费
@property (weak, nonatomic) IBOutlet UILabel *bonusPriceLabel;// 红包
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;// 实付
@property (weak, nonatomic) IBOutlet UILabel *hopeTimeLabel;// 期望送达时间
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;// 备注
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (nonatomic, copy) PushMapView push;


@property (weak, nonatomic) IBOutlet UIButton *orderReceivingBtn;// 接单按钮

@property (nonatomic, assign) id<OrderDetailTableViewCellDelegate> delegate;


- (void)setDataWithModel:(BaseModel *)model;

@property (nonatomic, copy) RequestBlock request;
- (void)setBtnBlockWithModel:(BaseModel *)model;


@end

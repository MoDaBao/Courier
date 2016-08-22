//
//  CallOutTableViewCell.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/16.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitOrdrReceivingModel.h"
typedef void (^ClickBlock)(void);
typedef void(^OrderReceivingBlock)(NSString *);
@interface CallOutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图
@property (nonatomic, assign) CGFloat horizontalMargin;// 横向间隔
@property (nonatomic, assign) CGFloat verticalMargin;// 纵向间隔
@property (weak, nonatomic) IBOutlet UIButton *orderReceivingBtn;// 接单按钮
//@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单编号
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;// 号码标签
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeimage;// 订单类型

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *orderStatus;// 订单状态
@property (nonatomic, copy) ClickBlock click;// 接单按钮
@property (nonatomic, copy) OrderReceivingBlock orderRcceiving;

- (void)setDataWithModel:(WaitOrdrReceivingModel *)model;


@end

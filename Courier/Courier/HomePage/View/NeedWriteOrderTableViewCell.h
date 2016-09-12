//
//  NeedWriteOrderTableViewCell.h
//  Courier
//
//  Created by 莫大宝 on 16/6/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
typedef void (^ClickBlock)(void);

@interface NeedWriteOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;// 编号

//@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;// 订单类型
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImage;


@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *needWriteLabel;// 需填单标签

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间

@property (weak, nonatomic) IBOutlet UIButton *writeBtn;// 填单按钮

@property (nonatomic, copy) ClickBlock click;


- (void)setDataWithMolde:(BaseModel *)model;

@end

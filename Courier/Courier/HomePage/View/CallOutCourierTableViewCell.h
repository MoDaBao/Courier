//
//  CallOutCourierTableViewCell.h
//  Courier
//
//  Created by 莫大宝 on 16/7/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallOutCourierTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;// 内容试图
@property (nonatomic, assign) CGFloat horizontalMargin;// 横向间隔
@property (nonatomic, assign) CGFloat verticalMargin;// 纵向间隔
@property (weak, nonatomic) IBOutlet UIButton *orderReceivingBtn;// 接单按钮
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单编号
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;// 号码标签
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;// 用户昵称标签

@end

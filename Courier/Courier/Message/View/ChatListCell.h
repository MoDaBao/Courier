//
//  ChatListCell.h
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "BaseModel.h"
#import "ChatListModel.h"

@interface ChatListCell : RCConversationBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;// 订单类型

@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;// 支付状态

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;// 支付方式

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;// 距离

@property (weak, nonatomic) IBOutlet UILabel *deliveryStatusLabel;// 配送状态

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;// 订单号

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;// 下单时间

@property (weak, nonatomic) IBOutlet UILabel *lastMessage;// 当前对话中的最后一条消息
@property (strong, nonatomic) UIView *line;// 分割线
@property (weak, nonatomic) IBOutlet UILabel *time;// 最后一条消息发送时间
@property (weak, nonatomic) IBOutlet UILabel *userphone;
@property (weak, nonatomic) IBOutlet UILabel *badge;


- (void)setDataModel:(RCConversationModel *)model BaseModel:(BaseModel *)baseModel;

- (void)setDataChatModel:(ChatListModel *)chat;

@end

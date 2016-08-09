//
//  ChatListModel.h
//  Courier
//
//  Created by 莫大宝 on 16/7/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListModel : NSObject

@property (nonatomic, copy) NSString *order_sn;// 订单号
@property (nonatomic, strong) NSNumber *type;// 订单类型
@property (nonatomic, copy) NSString *pay_status;// 支付状态
@property (nonatomic, copy) NSString *payment;// 支付方式
@property (nonatomic, copy) NSString *distance;// 距离
@property (nonatomic, copy) NSString *create;// 下单时间
@property (nonatomic, copy) NSString *status;// 订单状态
@property (nonatomic, copy) NSString *name;// 用户昵称
@property (nonatomic, copy) NSString *userphone;
@property (nonatomic, copy) NSString *userid;
@property(nonatomic) RCConversationModelType conversationModelType;
//@property (nonatomic, strong) RCTextMessage *lastMessage;
@property (nonatomic, strong) RCConversationModel *conversationModel;
@property(nonatomic, assign) RCConversationType conversationType;



@end

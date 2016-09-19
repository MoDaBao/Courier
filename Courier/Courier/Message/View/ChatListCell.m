//
//  ChatListCell.m
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ChatListCell.h"

@interface ChatListCell ()

@property (nonatomic, copy) NSString *userid;

@end

@implementation ChatListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    self.icon.layer.cornerRadius = 35 * .5;
    self.icon.clipsToBounds = YES;
    self.icon.layer.borderColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0].CGColor;
    self.icon.layer.borderWidth = 1;
    
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
    
    // 距离标签
    self.distanceLabel.layer.cornerRadius = 3;
    self.distanceLabel.clipsToBounds = YES;
    self.distanceLabel.backgroundColor = [UIColor colorWithRed:244 / 255.0f green:143 / 255.0f blue:177 / 255.0f alpha:1.0];
    
    // 审核标签
    self.deliveryStatusLabel.layer.cornerRadius = 3;
    self.deliveryStatusLabel.clipsToBounds = YES;
    //    self.checkLabel.text = @"已完成";
    self.deliveryStatusLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:190 / 255.0f blue:231 / 255.0f alpha:1.0];
    
    
    
    float sortaPixel = 1.0/ [UIScreen mainScreen].scale;
    self.line = [[UIView alloc] init];
    self.line.frame = CGRectMake(0,125,kScreenWidth, sortaPixel);
    self.line.backgroundColor = [UIColor colorWithRed:193  / 255.0 green:26 / 255.0 blue:32 / 255.0 alpha:1.0];
    [self addSubview:self.line];
    
//    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
//    self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    
    self.badge.layer.cornerRadius = self.badge.height * .5;
    self.badge.clipsToBounds = YES;
    self.badge.textColor = [UIColor whiteColor];
    self.badge.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.hidden = YES;
    
    
    
}


//- (void)setDataModel:(RCConversationModel *)model BaseModel:(BaseModel *)baseModel {
////    self.testLabel.text = [[model.jsonDict allValues] firstObject];
//    
//    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
//        RCTextMessage *message = (RCTextMessage *)model.lastestMessage;
//        NSLog(@"%@",message.content);
//        self.lastMessage.text = message.content;
//    } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
//        NSLog(@"tu pian ");
//        self.lastMessage.text = @"[图片]";
//    } else {
//        self.lastMessage.text = @"新消息";
//    }
//    
//}

- (void)request {
    NSDictionary *dic = @{@"api":@"getUser",@"version":@"1",@"userid":[NSString stringWithFormat:@"0%@",_userid]};
    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        if (!result.intValue) {
            NSLog(@"获取用户信息成功");
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            
            NSString *pic = dataDic[@"user"][@"pic"];
            NSLog(@"dataDic = %@",dataDic);
//            [self.icon sd_setImageWithURL:[NSURL URLWithString:pic]];
            
            [self.icon sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"img_22"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}


- (void)setDataChatModel:(ChatListModel *)chat {
    _userid = chat.userid;
    
    
    // 订单类型
    if (chat.type.intValue == 1) {
        self.orderTypeLabel.text = @"帮我拿";
    } else if (chat.type.intValue == 2) {
        self.orderTypeLabel.text = @"帮我送";
    } else {
        self.orderTypeLabel.text = @"帮我买";
    }
    
    // 支付状态
    if (!chat.pay_status.boolValue) {
        self.payStatusLabel.text = @"未支付";
    } else {
        self.payStatusLabel.text = @"已支付";
    }
    
    // 支付方式
    if (chat.payment.intValue == 1) {
        self.paymentLabel.text = @"支付宝";
    } else if (chat.payment.intValue == 2) {
        self.paymentLabel.text = @"微信";
    } else if (chat.payment.intValue == 3) {
        self.paymentLabel.text = @"银联";
    } else {
        self.paymentLabel.text = @"货到付款";
    }
    
    
    self.distanceLabel.text = [NSString stringWithFormat:@"距%.2fkm",chat.distance.floatValue / 1000.0];// 距离
    //    self.deliveryStatusLabel.text = @"配送中";// 配送状态
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号： %@",chat.order_sn];// 订单号
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间： %@",chat.create];// 下单时间
//    NSString *name = ch
//    self.userphone.text = [NSString stringWithFormat:@"%@%@",chat.name, chat.userphone];
    self.userphone.text = chat.userphone;

    
    switch ([chat.status integerValue])
    {
     
        case 0:
            self.deliveryStatusLabel.text = @"未填单";
            break;
        case 1:
            self.deliveryStatusLabel.text = @"未填单";
            break;
        case 2:
            self.deliveryStatusLabel.text = @"已接单";
            break;
        case 3:
            self.deliveryStatusLabel.text = @"正在路上";
            break;
        case 4:
            self.deliveryStatusLabel.text = @"正在配送";
            break;
        case 5:
            self.deliveryStatusLabel.text = @"已送达";
            break;
        case 6:
            self.deliveryStatusLabel.text = @"已完成";
            break;
        case 7:
            self.deliveryStatusLabel.text = @"正在退款";
            break;
        case 8:
            self.deliveryStatusLabel.text = @"已取消";
            break;
        case 9:
            self.deliveryStatusLabel.text = @"未填单";
            break;
        case 10:
            self.deliveryStatusLabel.text = @"审核中";
            break;
            
        default:
            break;
    }
    
    if (chat.conversationModel) {
        if ([chat.conversationModel.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *message = (RCTextMessage *)chat.conversationModel.lastestMessage;
            NSLog(@"%@",message.content);
            self.lastMessage.text = message.content;
        } else if ([chat.conversationModel.lastestMessage isKindOfClass:[RCImageMessage class]]) {
            NSLog(@"tu pian ");
            self.lastMessage.text = @"[图片]";
        } else {
            self.lastMessage.text = @"新消息";
        }
        
        if (chat.conversationModel.unreadMessageCount >= 99) {
            self.badge.text = @"99";
            self.badge.hidden = NO;
        } else if (chat.conversationModel.unreadMessageCount == 0) {
            self.badge.hidden = YES;
        } else {
            self.badge.text = [NSString stringWithFormat:@"%ld",(long)chat.conversationModel.unreadMessageCount];
            self.badge.hidden = NO;
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:chat.conversationModel.sentTime / 1000];
        //将一个日期对象转化为字符串对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置日期与字符串互转的格式
        [formatter setDateFormat:@"HH:mm"];
        //将日期转化为字符串
        NSString *dateStr = [formatter stringFromDate:date];
        
        self.time.text = dateStr;
    } else {
        self.lastMessage.text = @"无消息";
        self.badge.hidden = YES;
        self.time.text = @"";
    }
    
    
    
    [self request];// 请求数据加载头像
    
}


@end

//
//  CourierInfo.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourierInfoModel : NSObject

@property (nonatomic, copy) NSString *buy_online;// 在线支付的商品价格
@property (nonatomic, copy) NSString *buy_unonline;// 货到付款的商品价格
@property (nonatomic, copy) NSString *count;// 今日总单数
@property (nonatomic, copy) NSString *db_online;// 在线支付跑腿费用
@property (nonatomic, copy) NSString *db_unonline;// 活到付款的跑腿费用
@property (nonatomic, copy) NSString *distance;// 今日总距离
@property (nonatomic, copy) NSString *pay_online;// 今日线上支付
@property (nonatomic, copy) NSString *pay_unonline;// 今日货到付款
@property (nonatomic, copy) NSString *pcount;//
@property (nonatomic, copy) NSString *pid;// 跑腿id
@property (nonatomic, copy) NSString *ycount;//
@property (nonatomic, copy) NSString *zcount;//
@property (nonatomic, copy) NSString *zscore;// 总分数
@property (nonatomic, copy) NSString *zservice;// 总服务分
@property (nonatomic, copy) NSString *zspeed;// 总配送分

//"buy_online" = 0;
//"buy_unonline" = 0;
//count = 0;
//"db_online" = 0;
//"db_unonline" = 0;
//distance = 0;
//"pay_online" = 0;
//"pay_unonline" = 0;
//pcount = 9;
//pid = 1;
//ycount = 36;
//zcount = 36;
//zscore = "4.33333";
//zservice = "4.33333";
//zspeed = "4.33333";

@end

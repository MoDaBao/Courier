//
//  UserInfoManager.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourierInfoManager : NSObject

+ (CourierInfoManager *)shareInstance;

//  添加跑腿信息
- (void)setCourierInfoWithDic:(NSDictionary *)dic;
//  移除所有跑腿信息
- (void)removeAllCourierInfo;

//  保存跑腿登录手机号码
- (void)saveCourierPhone:(NSString *)phone;
//  获取跑腿登录手机号码
- (NSString *)getCourierPhone;
//  删除跑腿登录手机号码
- (void)deleteCourierPhone;

//  保存跑腿id
- (void)saveCourierPid:(NSString *)pid;
//  获取跑腿id
- (NSString *)getCourierPid;
//  删除跑腿id
- (void)deleteCourierPid;


//  保存跑腿昵称
- (void)saveCourierAlias:(NSString *)alias;
//  获取跑腿昵称
- (NSString *)getCourierAlias;
//  删除跑腿昵称
- (void)deleteCourierAlias;

//  保存跑腿在线状态
- (void)saveCourierOnlineStatus:(NSString *)is_online;
//  获取跑腿在线状态
- (NSString *)getCourierOnlineStatus;
//  删除跑腿在线状态
- (void)deleteCourierOnlineStatus;

// 保存跑腿融云token
- (void)saveCourierToken:(NSString *)rtoken;
// 获取跑腿融云token
- (NSString *)getCourierToken;
// 删除跑瑞融云token
- (void)deleteCourierToken;




@end

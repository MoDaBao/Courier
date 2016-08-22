//
//  UserInfoManager.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CourierInfoManager.h"

@implementation CourierInfoManager

+ (CourierInfoManager *)shareInstance {
    static CourierInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CourierInfoManager alloc] init];
    });
    return manager;
}

//  添加跑腿信息
- (void)setCourierInfoWithDic:(NSDictionary *)dic {
    [self saveCourierPid:dic[@"pid"]];
    [self saveCourierPhone:dic[@"phone"]];
    [self saveCourierAlias:dic[@"alias"]];
    [self saveCourierOnlineStatus:dic[@"is_online"]];
    [self saveCourierToken:dic[@"rtoken"]];
    [self saveCourierPic:dic[@"pic"]];
}
//  移除所有跑腿信息
- (void)removeAllCourierInfo {
    [self deleteCourierPid];
    [self deleteCourierPhone];
    [self deleteCourierAlias];
    [self deleteCourierOnlineStatus];
    [self deleteCourierToken];
    [self deleteCourierPic];
}

//  保存跑腿登录手机号码
- (void)saveCourierPhone:(NSString *)phone {
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取跑腿登录手机号码
- (NSString *)getCourierPhone {
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    if (!phone) {
        return @" ";
    }
    return phone;
}
//  删除跑腿登录手机号码
- (void)deleteCourierPhone {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  保存跑腿id
- (void)saveCourierPid:(NSString *)pid {
    [[NSUserDefaults standardUserDefaults] setObject:pid forKey:@"pid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取跑腿id
- (NSString *)getCourierPid {
    NSString *pid = [[NSUserDefaults standardUserDefaults] objectForKey:@"pid"];
    if (!pid) {
        return @" ";
    }
    return pid;
}
//  删除跑腿id
- (void)deleteCourierPid {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  保存跑腿昵称
- (void)saveCourierAlias:(NSString *)alias {
    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取跑腿昵称
- (NSString *)getCourierAlias {
    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    if (!alias) {
        return @" ";
    }
    return alias;
}
//  删除跑腿昵称
- (void)deleteCourierAlias {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  保存跑腿在线状态
- (void)saveCourierOnlineStatus:(NSString *)is_online {
    [[NSUserDefaults standardUserDefaults] setObject:is_online forKey:@"is_online"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取跑腿在线状态
- (NSString *)getCourierOnlineStatus {
    NSString *is_online = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_online"];
    if (!is_online) {
        return @" ";
    }
    return is_online;
}
//  删除跑腿在线状态
- (void)deleteCourierOnlineStatus {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"is_online"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 保存跑腿融云token
- (void)saveCourierToken:(NSString *)rtoken {
    [[NSUserDefaults standardUserDefaults] setObject:rtoken forKey:@"rtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取跑腿融云token
- (NSString *)getCourierToken {
    NSString *rtoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rtoken"];
    if (!rtoken) {
        return @" ";
    }
    return rtoken;
}
// 删除跑瑞融云token
- (void)deleteCourierToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"rtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 保存跑腿头像
- (void)saveCourierPic:(NSString *)pic {
    [[NSUserDefaults standardUserDefaults] setObject:pic forKey:@"pic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取跑腿头像
- (NSString *)getCourierPic {
    NSString *pic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pic"];
    if (!pic) {
        return @" ";
    }
    return pic;
}

// 删除跑腿头像
- (void)deleteCourierPic {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

//
//  MainTabBarController.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "PersonViewController.h"
#import "MainNavigationController.h"
#import "SimpleMessage.h"
#import "LoginViewController.h"
#import "TestChatListViewController.h"
#import "AppDelegate.h"
#import "WaitOrderReceivingViewController.h"
#import "WaitOrdrReceivingModel.h"
#import "BaseModel.h"
#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface MainTabBarController ()<MainTabBarDelegate, RCIMUserInfoDataSource, AMapLocationManagerDelegate, RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate, UIAlertViewDelegate, AMapSearchDelegate, RCIMReceiveMessageDelegate, LoginViewControllerDelegate>
@property(nonatomic, weak)MainTabBar *mainTabBar;

@property (nonatomic, strong) AMapLocationManager *locationManager;// 定位管理对象
@property (nonatomic, strong) AMapSearchAPI *search;
// 位置信息
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

//@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, strong) NSTimer *timer;// 30秒上传跑腿位置的计时器
@property (nonatomic, strong) NSTimer *checkOrderTimer;// 60秒监测订单的计时器

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self SetupMainTabBar];
    [self SetupAllControllers];
    
    
    self.longitude = @"20";
    self.latitude = @"20";
    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // 定位
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    [self.locationManager startUpdatingLocation];// 开启持续定位
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    

    if (![[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {// 当用户已经登录的时候
        [self initRongAndSendAddress];// 初始化融云
        [self initTimer];//
        // 如果是在线状态使用别名标识设备
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            [JPUSHService setAlias:[NSString stringWithFormat:@"puser_%@",[[CourierInfoManager shareInstance] getCourierPid]] callbackSelector:nil object:nil];
            
        }
    }
    
    
}


/** 初始化融云 上传跑腿位置 */
- (void)initRongAndSendAddress {
    // 8w7jv4qb7h9ey  生产环境
    // mgb7ka1nbtzxg  开发环境
    // 融云初始化
    [[RCIM sharedRCIM] initWithAppKey:@"8w7jv4qb7h9ey"];
        [[RCIMClient sharedRCIMClient]registerMessageType:SimpleMessage.class];
    
    
    [[RCIM sharedRCIM] connectWithToken:[[CourierInfoManager shareInstance] getCourierToken] success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"RCtoken错误");
    }];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    // 设置计时器每隔三十秒向服务器上传一次跑腿的位置
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(courierAddress) userInfo:nil repeats:YES];
    }
   
    
}

- (void)initTimer {
    if (!_checkOrderTimer) {
        _checkOrderTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkOrder) userInfo:nil repeats:YES];
    }
}

- (void)checkOrder {
    
//    if ([self.tabCheckDelegate respondsToSelector:@selector(checkOrder)]) {
//        [self.tabCheckDelegate checkOrder];
//    }
    
    if (![[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            NSDictionary *dic = @{@"api":@"pgetorders", @"version":@"1", @"start":@"0", @"num":@"10"};
            NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject = %@",responseObject);
                NSNumber *result = responseObject[@"status"];
                if (!result.integerValue) {
                    NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                    NSLog(@"dataDic = %@",dataDic);
                    if (dataDic.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIViewController *vc = nil;
                            if (self.selectedIndex == 0) {
                                vc = self.homeVc.navigationController.childViewControllers.lastObject;
                            } else if (self.selectedIndex == 1) {
                                vc = self.chatListVC.navigationController.childViewControllers.lastObject;
                            } else if (self.selectedIndex == 2) {
                                vc = self.personVC.navigationController.childViewControllers.lastObject;
                            }
                            
                            if (![vc isKindOfClass:[WaitOrderReceivingViewController class]]) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前有可接订单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [alert show];
                                // 加上声音和震动提示 如果在后台要有推送
                                
                                //系统声音
                                AudioServicesPlaySystemSound(1007);
                                //震动
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                
                                
                                //测试推送
                                UILocalNotification *localnotification;
                                if (!localnotification)
                                {
                                    localnotification = [[UILocalNotification alloc]init];
                                }
                                
                                localnotification.repeatInterval = 0;
                                /**
                                 *  设置推送的相关属性
                                 */
                                localnotification.alertBody = @"您当前有可接订单";//通知具体内容
                                localnotification.soundName = UILocalNotificationDefaultSoundName;//通知时的音效
                                NSDictionary *dit_noti = [NSDictionary dictionaryWithObject:@"affair.schedule" forKey:@"id"];
                                localnotification.userInfo = dit_noti;
                                
                                /**
                                 *  调度本地通知,通知会在特定时间发出
                                 */
                                [[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];
                                
                                
                            }
                            
                        });
                    }
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error is %@",error);
            }];
        }
    }
    
    
}

#pragma mark -----LoginVC代理方法-----

- (void)initRong {
    [self initRongAndSendAddress];
}

- (void)initCheckOrderTimer {
    [self initTimer];
}


#pragma mark -----融云代理方法-----

// 一个账号不能同时登录两台设备
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"xxxx");
    
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        // 当被迫下线的时候就先移除当前用户的登录信息
        [[CourierInfoManager shareInstance] removeAllCourierInfo];
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        [[RCIMClient sharedRCIMClient]logout];// 退出融云
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"提示"
                              
                              message:@"您"
                              
                              @"的帐号在别的设备上登录，您被迫下线！"
                              
                              delegate:self
                              
                              cancelButtonTitle:@"知道了"
                              
                              otherButtonTitles:nil, nil];
        alert.tag = 7777;
        [alert show];
        
        // 将页面跳到首页页面
        if (self.selectedIndex == 0) {
            [self.homeVc.navigationController popToRootViewControllerAnimated:NO];
        } else if (self.selectedIndex == 1) {
            [self.chatListVC.navigationController popToRootViewControllerAnimated:NO];
            self.selectedIndex = 0;
        }
        
    }
    
}

// 最先开始是把收到新消息弹窗的代码写在了这里 现在改到了消息列表的视图控制器中
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
//    _targetId = message.targetId;
//    NSString *userid = [message.senderUserId substringFromIndex:1];
//    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"orderinfo",@"api",@"1",@"version",userid,@"userid",message.targetId,@"order_sn",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"equment",nil];
//    NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dataDic];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"%@",responseObject);
//        NSNumber *result = responseObject[@"status"];
//        if (!result.integerValue) {
//            NSDictionary *data = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
//            NSLog(@"%@",data);
//            BaseModel *model = [[BaseModel alloc] init];
//            [model setValuesForKeysWithDictionary:data[@"orderlist"][0]];
//            self.baseModel = model;
//            NSLog(@"%@",_baseModel);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (self.selectedIndex == 1) {
//                    if ([self.chatListVC.navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]) {//  如果当前栈顶元素为聊天页面
//                        ChatViewController *chatVC = self.chatListVC.navigationController.viewControllers.lastObject;
//                        if (![chatVC.model.order_sn isEqualToString:_baseModel.order_sn]) {// 如果当前聊天页面的和接收到消息的订单号不一致 弹窗提示
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            alert.tag = 1234;
//                            [alert show];
//                            
//                        }
//                    }
//                    
//                    
//                } else {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    alert.tag = 1234;
//                    [alert show];
//                }
//            });
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error is %@",error);
//    }];
   
}


// 获取聊天用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    NSLog(@"userid = %@",userId);
    
    NSDictionary *dic = @{@"api":@"getUser",@"version":@"1",@"userid":userId};
    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        if (!result.intValue) {
            NSLog(@"获取用户信息成功");
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"dataDic = %@",dataDic);
            RCUserInfo *user = [[RCUserInfo alloc] init];
            user.userId = userId;
            if (dataDic[@"user"][@"alias"] == [NSNull null]) {
                user.name = dataDic[@"user"][@"phone"];
            } else {
                user.name = dataDic[@"user"][@"alias"];
            }
            
            user.portraitUri = dataDic[@"user"][@"pic"];
            return completion(user);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
    
    
    
}

#pragma mark -----UIAlertView代理-----

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 7777) {// 当前弹窗为被迫下线的弹窗
//        [[CourierInfoManager shareInstance] removeAllCourierInfo];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        MainNavigationController *naVC = [[MainNavigationController alloc] initWithRootViewController:loginVC];
        // 此处应该要撤销计时器
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:naVC animated:YES completion:nil];
        

    } else if (alertView.tag == 1234) {
        
//        ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:_baseModel];
//        //设置会话的类型，如单聊、讨论[组、群聊、聊天室、客服、公众服务会话等
//        chatVC.conversationType = ConversationType_GROUP;
//        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//        chatVC.targetId = _baseModel.order_sn;
//        
//        //设置聊天会话界面要显示的标题
//        chatVC.title = self.baseModel.userphone;
//        
//        
//        //显示聊天会话界面
////        [self.navigationController pushViewController:chatVC animated:YES];
//        
//        if (self.selectedIndex == 0) {
//            [self.homeVc.navigationController pushViewController:chatVC animated:YES];
//        } else if (self.selectedIndex == 1) {
//            [self.chatListVC.navigationController pushViewController:chatVC animated:YES];
//        } else {
//            [self.personVC.navigationController pushViewController:chatVC animated:YES];
//        }
        
    }
}



#pragma mark -----高德代理-----

//  定位回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    NSLog(@"MianTabBarController成功定位回调");
    self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

// 逆地理编码完成的回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    [self.delegate setAddress:response.regeocode.formattedAddress];// 让代理设置位置
    if ([self.tabdelegate respondsToSelector:@selector(setAddress:)]) {
        [self.tabdelegate setAddress:[NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building, response.regeocode.addressComponent.streetNumber.street, response.regeocode.addressComponent.streetNumber.number]];
    }
    
    
}

#pragma mark -----上传跑腿位置-----
/** 上传跑腿位置*/
- (void)courierAddress {
    
//    NSLog(@"上传了一次");
    
    
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        
        AMapReGeocodeSearchRequest *reGeo = [[AMapReGeocodeSearchRequest alloc] init];
        reGeo.location = [AMapGeoPoint locationWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        reGeo.radius = 200;
        reGeo.requireExtension = YES;
        //发起逆向地理编码
        //初始化检索对象
        
        [_search AMapReGoecodeSearch:reGeo];
        
        
        NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        if ([latitude isEqualToString:@"20"] || [longitude isEqualToString:@"20"]) {// 已开启定位功能
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        } else {
            // POST请求参数
            NSDictionary *dic = @{@"api":@"courierAddress", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"longitude":self.longitude, @"latitude":self.latitude};
            NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
            NSString *parmeter = [EncryptionAndDecryption encryptionWithDic:dic];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:REQUESTURL parameters:@{@"key":parmeter} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSNumber *result = responseObject[@"status"];
                if (result.intValue) {
                    NSLog(@"上传跑腿位置失败");
                } else {
                    NSLog(@"上传跑腿位置成功");
                }
                NSLog(@"respopnseObject = %@",[responseObject class]);
                NSLog(@"%@", responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error is %@",error);
            }];
        }
        
        
    }
    
    
    
    
}


#pragma mark -----自定义tabBarController方法-----
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        for (UIView *child in self.tabBar.subviews) {
            if ([child isKindOfClass:[UIControl class]]) {
                [child removeFromSuperview];
            }
        }

}


- (void)SetupMainTabBar{
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{
    NSArray *titles = @[@"首页",@"消息", @"我的"];
    NSArray *images = @[@"homepage-black", @"message-black", @"me-black"];
    NSArray *selectedImages = @[@"homepage-red", @"message-red", @"me-red"];
    

    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    self.homeVc = homeVC;

    
    TestChatListViewController *chatListVC = [[TestChatListViewController alloc] init];
    self.chatListVC = chatListVC;
    
    
    PersonViewController *personVC = [[PersonViewController alloc]init];
    self.personVC = personVC;    
    
    NSArray *viewControllers = @[homeVC, chatListVC,personVC];
    
    for (NSInteger i = 0; i < viewControllers.count; i++) {
        UIViewController *childVc = viewControllers[i];
        [self SetupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}



#pragma mark -----------------· ---mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
}

//- (void)tabBarClickWriteButton:(MainTabBar *)tabBar{
////    WriteViewController *writeVc = [[WriteViewController alloc] init];
////    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
////    
////    [self presentViewController:nav animated:YES completion:nil];
//}
@end

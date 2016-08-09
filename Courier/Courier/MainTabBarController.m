//
//  MainTabBarController.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "MessageViewController.h"
#import "PersonViewController.h"
#import "MainNavigationController.h"
#import "ChatListViewController.h"
#import "SimpleMessage.h"
#import "LoginViewController.h"
#import "TestChatListViewController.h"
#import "AppDelegate.h"
#import "WaitOrderReceivingViewController.h"
#import "WaitOrdrReceivingModel.h"
#import "BaseModel.h"
#import "ChatViewController.h"


@interface MainTabBarController ()<MainTabBarDelegate, RCIMUserInfoDataSource, AMapLocationManagerDelegate, RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate, UIAlertViewDelegate, AMapSearchDelegate, RCIMReceiveMessageDelegate>
@property(nonatomic, weak)MainTabBar *mainTabBar;

//@property(nonatomic, strong)MessageViewController *messageVc;
//@property (nonatomic, strong) ChatListViewController *chatListVC;



@property (nonatomic, strong) AMapLocationManager *locationManager;// 定位管理对象
@property (nonatomic, strong) AMapSearchAPI *search;
// 位置信息
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

//@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, strong) BaseModel *baseModel;

@end

@implementation MainTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self SetupMainTabBar];
    [self SetupAllControllers];
    
    
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
    

    if (![[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {
        [self initRongAndSendAddress];
    }
    
    
    
}


/** 初始化融云 上传跑腿位置 */
- (void)initRongAndSendAddress {
    
    // 融云初始化
    [[RCIM sharedRCIM] initWithAppKey:@"mgb7ka1nbtzxg"];
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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(courierAddress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:@"2333"];
    
    self.longitude = @"20";
    self.latitude = @"20";
    
}

#pragma mark -----融云代理方法-----

// 一个账号不能同时登录两台设备
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"xxxx");
    /*
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"提示"
                              
                              message:@"您"
                              
                              @"的帐号在别的设备上登录，您被迫下线！"
                              
                              delegate:self
                              
                              cancelButtonTitle:@"知道了"
                              
                              otherButtonTitles:nil, nil];
        alert.tag = 7777;
        [alert show];
    }
     */
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
//    _targetId = message.targetId;
    NSString *userid = [message.senderUserId substringFromIndex:1];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"orderinfo",@"api",@"1",@"version",userid,@"userid",message.targetId,@"order_sn",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"equment",nil];
    NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dataDic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        if (!result.integerValue) {
            NSDictionary *data = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"%@",data);
            BaseModel *model = [[BaseModel alloc] init];
            [model setValuesForKeysWithDictionary:data[@"orderlist"][0]];
            self.baseModel = model;
            NSLog(@"%@",_baseModel);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.selectedIndex == 1) {
                    if ([self.chatListVC.navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]) {//  如果当前栈顶元素为聊天页面
                        ChatViewController *chatVC = self.chatListVC.navigationController.viewControllers.lastObject;
                        if (![chatVC.model.order_sn isEqualToString:_baseModel.order_sn]) {// 如果当前聊天页面的和接收到消息的订单号不一致 弹窗提示
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 1234;
                            [alert show];
                            
                        }
                    }
                    
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 1234;
                    [alert show];
                }
            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
   
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
    if (alertView.tag == 7777) {
        if (![[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@" "]) {// 退出登录时当在线状态为在线时改成下班状态
            NSString *parameterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"isWork", @"is_online":@"0",@"version":@"1",@"pid":[[CourierInfoManager shareInstance] getCourierPid], @"phone":[[CourierInfoManager shareInstance] getCourierPhone]}];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:REQUESTURL parameters:@{@"key":parameterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"data = %@",[EncryptionAndDecryption decryptionWithString:responseObject[@"data"]]);
                if (![responseObject[@"status"] integerValue]) {
                    NSLog(@"成功");
                    //                    [[CourierInfoManager shareInstance] saveCourierOnlineStatus:[NSString stringWithFormat:@"0"]];
                    [[CourierInfoManager shareInstance] removeAllCourierInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 模态弹出登录页面
                        [[CourierInfoManager shareInstance] removeAllCourierInfo];
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        // 此处应该要撤销计时器
                        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                        [delegate.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
                        //                    [self presentViewController:loginVC animated:YES completion:nil];
                    });
                } else {
                    NSLog(@"失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error is %@",error);
            }];
        }
    } else if (alertView.tag == 1234) {
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:_baseModel];
        //设置会话的类型，如单聊、讨论[组、群聊、聊天室、客服、公众服务会话等
        chatVC.conversationType = ConversationType_GROUP;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chatVC.targetId = _baseModel.order_sn;
        
        //设置聊天会话界面要显示的标题
        chatVC.title = self.baseModel.userphone;
        
        
        //显示聊天会话界面
//        [self.navigationController pushViewController:chatVC animated:YES];
        
        if (self.selectedIndex == 0) {
            [self.homeVc.navigationController pushViewController:chatVC animated:YES];
        } else if (self.selectedIndex == 1) {
            [self.chatListVC.navigationController pushViewController:chatVC animated:YES];
        } else {
            [self.personVC.navigationController pushViewController:chatVC animated:YES];
        }
        
    }
}



#pragma mark -----高德代理-----

//  定位回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    [self.delegate setAddress:response.regeocode.formattedAddress];// 让代理设置位置
    if ([self.delegate respondsToSelector:@selector(setAddress:)]) {
        [self.delegate setAddress:[NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building, response.regeocode.addressComponent.streetNumber.street, response.regeocode.addressComponent.streetNumber.number]];
    }
    
    
}

#pragma mark -----上传跑腿位置-----
/** 上传跑腿位置*/
- (void)courierAddress {
    
    NSLog(@"上传了一次");
    
    AMapReGeocodeSearchRequest *reGeo = [[AMapReGeocodeSearchRequest alloc] init];
    reGeo.location = [AMapGeoPoint locationWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
    reGeo.radius = 200;
    reGeo.requireExtension = YES;
    //发起逆向地理编码
    //初始化检索对象
    
    [_search AMapReGoecodeSearch:reGeo];
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        // POST请求参数
        NSDictionary *dic = @{@"api":@"courierAddress", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"longitude":self.longitude, @"latitude":self.latitude};
        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
        NSString *parmeter = [EncryptionAndDecryption encryptionWithDic:dic];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":parmeter} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = responseObject[@"status"];
            if (result.intValue) {
                NSLog(@"失败");
            } else {
                NSLog(@"成功");
            }
            NSLog(@"respopnseObject = %@",[responseObject class]);
            NSLog(@"%@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
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

    
//    ChatListViewController *chatListVC = [[ChatListViewController alloc]init];
//    self.chatListVC = chatListVC;
    
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

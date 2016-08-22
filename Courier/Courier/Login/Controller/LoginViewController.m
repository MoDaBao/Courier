//
//  LoginViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LoginViewController.h"
#import "MOTextField.h"
#import "TipMessageView.h"
#import "ManagerViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "SimpleMessage.h"
#import "BiaoShiViewController.h"
#import "MyMD5.h"

#define kTFMargin 20

@interface LoginViewController ()<UITextFieldDelegate, RCIMUserInfoDataSource, RCIMConnectionStatusDelegate, UIAlertViewDelegate, AMapSearchDelegate, RCIMReceiveMessageDelegate>

@property (nonatomic, strong) MOTextField *accountTF;// 账号
@property (nonatomic, strong) MOTextField *passwordTF;// 密码


@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) MainTabBarController *tabVC;

//@property (nonatomic, strong) AMapLocationManager *locationManager;// 定位管理对象

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)createView {
    // 关闭按钮  测试使用
    CGFloat btnMargin = 15;
    CGFloat btnWidth = 20;
    CGFloat btnHeight = btnWidth;
    CGFloat btnY = kStatusHeight + btnMargin;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenWidth - btnMargin - btnWidth, kStatusHeight + btnMargin, btnWidth, btnHeight);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeBtn];
    
    // logo
    CGFloat logoWidth = 65 * kScaleForWidth;
    CGFloat logoHeight = logoWidth;
    CGFloat logoY = btnY + btnHeight + btnMargin * 2;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - logoWidth) * 0.5, logoY, logoWidth, logoHeight)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    // 账号textField
    self.accountTF = [[MOTextField alloc] initWithFrame:CGRectMake(kTFMargin, 180 * kScaleForWidth, kScreenWidth - kTFMargin * 2, 40) placeholder:@"请输入账号" lineColor:[UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00] font:[UIFont systemFontOfSize:14]];
    self.accountTF.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountTF.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTF.textField.delegate = self;
    [self.accountTF.textField setTag:1000];
    [self.view addSubview:self.accountTF];
    
    // 密码textField
    self.passwordTF = [[MOTextField alloc] initWithFrame:CGRectMake(kTFMargin, 240 * kScaleForWidth, kScreenWidth - kTFMargin * 2, 40) placeholder:@"请输入密码" lineColor:[UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00] font:[UIFont systemFontOfSize:14]];
    self.passwordTF.textField.returnKeyType = UIReturnKeyDone;
    self.passwordTF.textField.keyboardType= UIKeyboardTypeAlphabet;
    self.passwordTF.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.passwordTF];
    [self.passwordTF.textField setTag:1001];
    self.passwordTF.textField.delegate = self;
    self.passwordTF.textField.secureTextEntry = YES;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kTFMargin, (self.passwordTF.y + self.passwordTF.height + 80) * kScaleForWidth, kScreenWidth - kTFMargin * 2, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00]];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = loginBtn.height * 0.45;// 设置圆角效果
    loginBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    loginBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    loginBtn.layer.shadowOpacity = .5;// 阴影透明度
    loginBtn.layer.shadowRadius = 4;// 阴影半径
    [self.view addSubview:loginBtn];
    
    // 镖师按钮
    UIButton *biaoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    biaoshiBtn.frame = CGRectMake(kTFMargin, (self.passwordTF.y + self.passwordTF.height + 80) * kScaleForWidth + 65, kScreenWidth - kTFMargin * 2, 40);
    [biaoshiBtn setTitle:@"申请镖师" forState:UIControlStateNormal];
    biaoshiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [biaoshiBtn setBackgroundColor:[UIColor lightGrayColor]];
    [biaoshiBtn addTarget:self action:@selector(shenqingbiaoshiBtn) forControlEvents:UIControlEventTouchUpInside];
    biaoshiBtn.layer.cornerRadius = loginBtn.height * 0.45;// 设置圆角效果
    biaoshiBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    biaoshiBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    biaoshiBtn.layer.shadowOpacity = .5;// 阴影透明度
    biaoshiBtn.layer.shadowRadius = 4;// 阴影半径
    [self.view addSubview:biaoshiBtn];
    
    // 添加手势回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    _tabVC = (MainTabBarController *)appdelegate.window.rootViewController;
    self.delegate = _tabVC;
    
    
    // 定位
//    self.locationManager = [[AMapLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    
//    //设置允许后台定位参数，保持不会被系统挂起
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
//    [self.locationManager startUpdatingLocation];// 开启持续定位
//    
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
//    _search = [[AMapSearchAPI alloc] init];
//    _search.delegate = self;

    [self createView];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    window.rootViewController = nav;
}

//申请镖师
- (void)shenqingbiaoshiBtn
{
    BiaoShiViewController *VC = [[BiaoShiViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


// 回收键盘
- (void)tap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    NSLog(@"登录");
    return YES;
}

// 限制输入位数11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1000) {// tag值为1000的是账号输入框
        NSString *str = [NSString stringWithFormat:@"%@%@",textField.text, string];
//        NSLog(@"length = %ld, str = %@, text = %@, replace = %@",str.length, str, textField.text, string);
        if (str.length > 11) {
            return NO;
        }
    }
    return YES;
}

//  关闭方法  测试
- (void)closed {
    NSLog(@"关闭");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  登录方法
- (void)login {
    NSLog(@"登录");
    
    // POST请求参数
    NSDictionary *dic = @{@"api":@"loginCourier", @"version":@"1", @"phone":self.accountTF.textField.text, @"pwd":self.passwordTF.textField.text};
    
    NSString *parameterStr = [EncryptionAndDecryption encryptionWithDic:dic];
    NSLog(@"replaceStr = %@",parameterStr);
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSLog(@"-----");
    [session POST:REQUESTURL parameters:@{@"key":parameterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-----");
        NSLog(@"%@",responseObject);
        
        if ([[responseObject[@"status"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"登录成功");

            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            // 先移除掉之前存储的信息
            [[CourierInfoManager shareInstance] removeAllCourierInfo];
            // 存储跑腿基本信息
            [[CourierInfoManager shareInstance]  setCourierInfoWithDic:dataDic];
            // 使用别名标识设备
            [JPUSHService setAlias:[NSString stringWithFormat:@"puser_%@",[[CourierInfoManager shareInstance] getCourierPid]] callbackSelector:nil object:nil];
            [self.delegate initRong];// 初始化融云
            
            /*
                NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType", @"iOS", @"BaseAppVersion", @"1.0.1", @"SystemVersion", [NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]], @"_userid_", [NSString stringWithFormat:@"00%@",[[CourierInfoManager shareInstance] getCourierPid]], @"avatar", [[CourierInfoManager shareInstance] getCourierPic], @"userid", [NSString stringWithFormat:@"00%@",[[CourierInfoManager shareInstance] getCourierPid]], @"username", [[CourierInfoManager shareInstance] getCourierAlias], @"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
                NSString *sign = [MyMD5 md5:str];
                NSDictionary *dic = @{@"BaseAppType":@"iOS", @"BaseAppVersion":@"1.0.1", @"SystemVersion":[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]], @"_sign_":sign, @"_userid_":[NSString stringWithFormat:@"00%@",[[CourierInfoManager shareInstance] getCourierPid]], @"avatar":[[CourierInfoManager shareInstance] getCourierPic], @"userid":[NSString stringWithFormat:@"00%@",[[CourierInfoManager shareInstance] getCourierPid]], @"username":[[CourierInfoManager shareInstance] getCourierAlias]};
                
                
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                session.requestSerializer = [AFJSONRequestSerializer serializer];
                session.responseSerializer = [AFJSONResponseSerializer serializer];
                [session POST:@"http://mapi.tzouyi.com/user/getToken" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"message"] isEqualToString:@"success"]) {
                        [[CourierInfoManager shareInstance] saveCourierToken:responseObject[@"data"][@"token"]];
//                        [self.delegate initRong];// 初始化融云
//                        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierToken]);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error is %@", error);
                }];
                */
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self dismissViewControllerAnimated:YES completion:nil];
//                if (!self.isDismiss) {
//                    UIApplication *application = [UIApplication sharedApplication];
//                    AppDelegate *delegate = application.delegate;
//                    ManagerViewController *managerVC = (ManagerViewController *)delegate.window.rootViewController;
//                    [managerVC setRootVC:[[MainTabBarController alloc] init]];
//                } else {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            });
        } else {
            // 提示框
            CGFloat margin = 100;
            CGFloat width = kScreenWidth - margin * 2;
            CGFloat height = 100;
            CGFloat tipY = (kScreenHeight - height) * .5;
            TipMessageView *tipView = [[TipMessageView alloc] initWithFrame:CGRectMake(margin, tipY, width, height) tip:responseObject[@"msg"]];
            [self.view addSubview:tipView];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}

///** 初始化融云 上传跑腿位置 */
//- (void)initRongAndSendAddress {
//    
//    
//    // 融云初始化
//    [[RCIM sharedRCIM] initWithAppKey:@"mgb7ka1nbtzxg"];
//    [[RCIMClient sharedRCIMClient]registerMessageType:SimpleMessage.class];
//    
//    
//    [[RCIM sharedRCIM] connectWithToken:[[CourierInfoManager shareInstance] getCourierToken] success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"RCtoken错误");
//    }];
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [RCIM sharedRCIM].connectionStatusDelegate = _tabVC;
//    [RCIM sharedRCIM].receiveMessageDelegate = _tabVC;
//    // 设置计时器每隔三十秒向服务器上传一次跑腿的位置
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(courierAddress) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:@"2333"];
//    
//    self.longitude = @"20";
//    self.latitude = @"20";
//    
//}

//// 一个账号不能同时登录两台设备
//- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
//    NSLog(@"您的账号已在另一台设备上上线");
//    
//    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
////        [self.delegate showAlert];
//        
//        
//        
//    }
//    
//}
//
//
//
//// 获取聊天用户信息
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
//    
//    NSLog(@"userid = %@",userId);
//    
//    NSDictionary *dic = @{@"api":@"getUser",@"version":@"1",@"userid":userId};
//    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        NSNumber *result = responseObject[@"status"];
//        if (!result.intValue) {
//            NSLog(@"获取用户信息成功");
//            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
//            NSLog(@"dataDic = %@",dataDic);
//            RCUserInfo *user = [[RCUserInfo alloc] init];
//            user.userId = userId;
//            if (dataDic[@"user"][@"alias"] == [NSNull null]) {
//                user.name = dataDic[@"user"][@"phone"];
//            } else {
//                user.name = dataDic[@"user"][@"alias"];
//            }
//            
//            user.portraitUri = dataDic[@"user"][@"pic"];
//            return completion(user);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error is %@",error);
//    }];
//    
//    
//    
//    
//}
//
////  定位回调
////- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
////    self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
////    self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
////    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"longitude"];
////    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"latitude"];
////    [[NSUserDefaults standardUserDefaults] synchronize];
////    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
////}
//
//
/** 上传跑腿位置*/
//- (void)courierAddress {
//    
//    NSLog(@"上传了一次");
//    
//    
////    AMapReGeocodeSearchRequest *reGeo = [[AMapReGeocodeSearchRequest alloc] init];
////    reGeo.location = [AMapGeoPoint locationWithLatitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue]];
////    reGeo.radius = 200;
////    reGeo.requireExtension = YES;
////    //发起逆向地理编码
////    //初始化检索对象
////    
////    [_search AMapReGoecodeSearch:reGeo];
//    
//    
//    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
//        // POST请求参数
//        NSDictionary *dic = @{@"api":@"courierAddress", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"longitude":self.longitude, @"latitude":self.latitude};
//        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
//        NSString *parmeter = [EncryptionAndDecryption encryptionWithDic:dic];
//        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        [session POST:REQUESTURL parameters:@{@"key":parmeter} progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSNumber *result = responseObject[@"status"];
//            if (result.intValue) {
//                NSLog(@"失败");
//            } else {
//                NSLog(@"成功");
//            }
//            NSLog(@"respopnseObject = %@",[responseObject class]);
//            NSLog(@"%@", responseObject);
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error is %@",error);
//        }];
//    }
//    
//    
//    
//    
//}

//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    //    [self.delegate setAddress:response.regeocode.formattedAddress];// 让代理设置位置
//    if ([self.delegate respondsToSelector:@selector(loginsetAddress:)]) {
//        [self.delegate loginsetAddress:[NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building, response.regeocode.addressComponent.streetNumber.street, response.regeocode.addressComponent.streetNumber.number]];
//    }
//    
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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

- (void)viewWillAppear:(BOOL)animated {
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
    

    [self createView];
    
}

//申请镖师
- (void)shenqingbiaoshiBtn {
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
//            [self.delegate initRong];// 初始化融云
            
            
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
                        if (responseObject[@"data"][@"token"] == [NSNull null]) {
                            
                        } else {
                            [[CourierInfoManager shareInstance] saveCourierToken:responseObject[@"data"][@"token"]];
                        }
                        
                        if ([self.delegate respondsToSelector:@selector(initRong)]) {
                            [self.delegate initRong];// 初始化融云
                        }
                        if ([self.delegate respondsToSelector:@selector(initCheckOrderTimer)]) {
                            [self.delegate initCheckOrderTimer];// 初始化订单检测提醒的计时器
                        }
                        
//                        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierToken]);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error is %@", error);
                }];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
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

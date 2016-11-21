//
//  HomePageViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageView.h"
#import "TipView.h"
#import "CallOutTableViewCell.h"
#import "FillOutAndPresentTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "OrderDetailDefaultTableViewCell.h"
#import "DeliveryTableViewCell.h"
#import "DeliveryDefaultTableViewCell.h"
#import "LoginViewController.h"
#import "HomePageItemView.h"
#import "WaitOrderReceivingViewController.h"
#import "DeliveryViewController.h"
#import "WriteInfoViewController.h"
#import "CheckingViewController.h"
#import "TodayInfoViewController.h"
#import "AlreadyDoneViewController.h"
#import "NeedWriteViewController.h"
#import "PathPlaningMapViewController.h"
#import "TestMapViewController.h"
#import "NetWorkRequestManager.h"
#import "WriteInfoView_2.h"
//如果要使用MD5算法进行加密，需要引入此框架
#import <CommonCrypto/CommonCrypto.h>
#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "TableHeaderView.h"
#import "WalletViewController.h"
#import "MyMD5.h"
#import "MainNavigationController.h"
#import "MapNavViewController.h"

#define SecretKey @"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"

@interface HomePageViewController ()<MainTabBarControllerDelegate>
@property (nonatomic, strong) HomePageView *homePageView;
@property (nonatomic, assign) BOOL isWork;// 是否为上班状态
@property (nonatomic, strong) UIButton *workBtn;// 上下班按钮

@property (nonatomic, strong) UILabel *courierAddress;

@property (nonatomic, strong) NSMutableArray *deliveryArray;
@property (nonatomic, strong) NSMutableArray *needWriteArray;

@property (nonatomic, assign) BOOL isShowWallet;// 是否显示钱包

@property (nonatomic, strong) UIView *wallet;

@end

@implementation HomePageViewController

- (NSMutableArray *)deliveryArray {
    if (!_deliveryArray) {
        self.deliveryArray = [NSMutableArray array];
    }
    return _deliveryArray;
}

- (NSMutableArray *)needWriteArray {
    if (!_needWriteArray) {
        self.needWriteArray = [NSMutableArray array];
    }
    return _needWriteArray;
}

//校验是否显示钱包
- (void)shifouxianshiqianbao {
    
    //http://client.local.courier.net/account/checkWallet       校验是否显示钱包
    //    {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12"}
    //    BaseAppType 系统类型：android 安卓 ios 苹果
    //    BaseAppVersion App版本号【三位计算，比如：1.0.0】
    //    SystemVersion 系统版本号
    //    _sign_ 签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
    //    _token_ 用户登录TOKEN 【md5（小写（用户ID+secretKey））】
    //    _userid_ 用户ID
    //    userid   用户ID
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.0.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSDictionary *dataDic = @{
                              @"BaseAppType":@"ios",
                              @"BaseAppVersion":@"1.0.1",
                              @"SystemVersion":[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],
                              @"_sign_":[MyMD5 md5:str],
                              @"_token_":[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],
                              @"_userid_":[[CourierInfoManager shareInstance] getCourierPid],
                              @"userid":[[CourierInfoManager shareInstance] getCourierPid]
                              };
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain",@"text/javascript",@"application/json",@"text/json",nil]];
    [session POST:@"http://mapi.tzouyi.com/account/checkWallet" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"success"]) {
            BOOL data = responseObject[@"data"];
            if (data) {
                _isShowWallet = YES;
            } else {
                _isShowWallet = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isShowWallet) {
                _wallet.hidden = NO;
            } else {
                _wallet.hidden = YES;
            }
        });
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    

    self.isWork = [[CourierInfoManager shareInstance] getCourierOnlineStatus].integerValue;// 0在线 1离线
    if (self.isWork) {// 在线
        [self.workBtn setBackgroundImage:[UIImage imageNamed:@"work"] forState:UIControlStateNormal];
        if ([self.courierAddress.text isEqualToString:@"下班了"]) {
            self.courierAddress.text = @"上班中，正在定位";
        }
        
    } else {// 下线
        [self.workBtn setBackgroundImage:[UIImage imageNamed:@"workout"] forState:UIControlStateNormal];
        self.courierAddress.text = @"下班了";
    }
    
    if ([[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {// 未登录时
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        MainNavigationController *naVC = [[MainNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
//        loginVC.delegate = self;
    } else {// 已登录
        // 如果是在线状态使用别名标识设备
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            [JPUSHService setAlias:[NSString stringWithFormat:@"puser_%@",[[CourierInfoManager shareInstance] getCourierPid]] callbackSelector:nil object:nil];
        } else {// 不在线
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        }
    }
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"] && ![[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {// 上班状态
        [self requestDeliveryData];
        [self requestNeedWriteData];
    }
    
    [self shifouxianshiqianbao];
    
}



#pragma mark -----tabVC的代理方法-----

// tabVC的代理方法
- (void)setAddress:(NSString *)address {
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        if (address.length == 0) {
            self.courierAddress.text = @"当前定位未开启，获取位置失败";
        } else if ([address isEqualToString:@"(null)(null)"]) {
            self.courierAddress.text = @"当前定位未开启，获取位置失败";
        } else {
            self.courierAddress.text = address;
        }
//        self.courierAddress.text = [address isEqualToString:@"(null)(null)"] ? @"当前定位未开启，获取位置失败" : address;
        
        CGFloat screenW = kScreenWidth;
        CGFloat width = [UILabel getWidthWithTitle:self.courierAddress.text font:self.courierAddress.font] > (screenW * 1.0 / 3.0 * 2) ? (screenW * 1.0 / 3.0 * 2) : [UILabel getWidthWithTitle:self.courierAddress.text font:self.courierAddress.font];
        self.courierAddress.width = width;
    }
    
    
    
}

// 创建钱包的视图

- (void)createWallet {
    _wallet = [[UIView alloc] initWithFrame:CGRectMake(0, self.homePageView.y + self.homePageView.height, kScreenWidth, 70)];
    _wallet.backgroundColor = self.homePageView.backgroundColor;
    [self.view addSubview:_wallet];
    
    
    CGFloat imgW = 20;
    CGFloat imgH = imgW;
    UIImageView *walletImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    walletImg.image = [UIImage imageNamed:@"money"];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGFloat walletW = [UILabel getWidthWithTitle:@"   我的钱包" font:font];
    CGFloat walletH = 30;
    CGFloat walletX = imgW;
    UIButton *walletBtn = [[UIButton alloc] initWithFrame:CGRectMake(walletX, 0, walletW, walletH)];
    walletBtn.imageView.contentMode = UIViewContentModeLeft;
    [walletBtn setTitle:@"我的钱包" forState:UIControlStateNormal];
    [walletBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [walletBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    walletBtn.titleLabel.font = font;
    
    CGFloat walletBtnViewW = imgW + walletW;
    CGFloat walletBtnViewX = (_wallet.width - walletBtnViewW) * .5;
    CGFloat walletBtnViewY = (_wallet.height - walletH) * .5;
    UIView *walletBtnView = [[UIView alloc] initWithFrame:CGRectMake(walletBtnViewX, walletBtnViewY, imgW + walletW, walletH)];
    walletImg.y = (walletBtnView.height - imgH) * .5;
    [walletBtnView addSubview:walletImg];
    [walletBtnView addSubview:walletBtn];
    
    [_wallet addSubview:walletBtnView];
    
    [self.view addSubview:_wallet];
    
    
    UIView *line = [[UIView alloc]initWithFrame:
                    
                    CGRectMake(0, _wallet.height - 1,kScreenWidth, 1)];
    
    line.backgroundColor = [UIColor colorWithRed:193  / 255.0 green:26 / 255.0 blue:32 / 255.0 alpha:1.0];
    
    [_wallet addSubview:line];//线是否加
    
    
    UIButton *walletClick = [UIButton buttonWithType:UIButtonTypeSystem];
    walletClick.frame = CGRectMake(0, 0, _wallet.width, _wallet.height);
    [walletClick addTarget:self action:@selector(walletClick) forControlEvents:UIControlEventTouchUpInside];
    [_wallet addSubview:walletClick];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    
    // 上下班按钮
    CGFloat workMargin = 15;
    CGFloat workW = 40;
    CGFloat workH = 20;
    CGFloat workX = kScreenWidth - workW - workMargin;
    CGFloat workY = 30;
    self.workBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.workBtn.frame = CGRectMake(workX, workY, workW, workH);
    [self.workBtn setBackgroundImage:[UIImage imageNamed:@"work"] forState:UIControlStateNormal];
    [self.workBtn addTarget:self action:@selector(work) forControlEvents:UIControlEventTouchUpInside];
    self.workBtn.adjustsImageWhenHighlighted = NO;// 关闭按钮的高亮效果
    [self.view addSubview:self.workBtn];
    
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    MainTabBarController *tabVC = (MainTabBarController *)appdelegate.window.rootViewController;
    
    
    // 地址
    self.courierAddress = [[UILabel alloc] initWithFrame:CGRectMake(workMargin, workY, 150, 20)];
    self.courierAddress.font = [UIFont systemFontOfSize:14];
    tabVC.tabdelegate = self;
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        self.courierAddress.text = @"上班中，正在定位";
//        tabVC.tabdelegate = self;
    } else {
        self.courierAddress.text = @"下班了";
    }
    
    [self.view addSubview:self.courierAddress];
    
    
    // logo
    CGFloat logoWidth = 65 * kScaleForWidth;
    CGFloat logoHeight = logoWidth;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - logoWidth) * 0.5, logoWidth, logoWidth, logoHeight)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    
    self.homePageView = [[HomePageView alloc] initWithFrame:CGRectMake(0, 150 * kScaleForWidth, kScreenWidth, 280 * kScaleForWidth)];
    self.homePageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.homePageView];
    
    
    [self addBlockAchive];// 给_homePageView添加Block实现
    
    
    // 测试
//    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    testBtn.frame = CGRectMake(100, 100 , 100, 30);
//    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
//    [testBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testBtn];
    
    // 添加钱包视图
    [self createWallet];
    
    
    // 还是测试De
//    TableHeaderView *test = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 40)];
//    [self.view addSubview:test];
    
    
    // 再来一个测试按钮
//    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    testButton.frame = CGRectMake(100, 200, 100, 30);
//    [testButton setTitle:@"接口调试按钮" forState:UIControlStateNormal];
//    [testButton addTarget:self action:@selector(testButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testButton];
    
}

- (void)walletClick {
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];

}


- (void)testButton {
    
//    [self zhangdanmingxi];
//    [self wodehuokuan];
    
    
    
}




// 测试方法
- (void)test {
    
//    MapNavViewController *mapNavVC = [[MapNavViewController alloc] init];
//    [self.navigationController pushViewController:mapNavVC animated:YES];
    
    
    
//    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"username",@"123",@"avatar",@"123",@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    
//    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[MainData getIOSVersion]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",userid]],@"_token_",userid,@"_userid_",userid,@"userid",userName,@"username",avatar,@"avatar",nil];
    
//    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"username",userName,@"avatar",avatar,@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
//    
//    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[MainData getIOSVersion]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",userid]],@"_token_",userid,@"_userid_",userid,@"userid",userName,@"username",avatar,@"avatar",nil];
    
//    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",
//                     @"BaseAppType",@"ios",
//                     @"BaseAppVersion",@"1.2.1",
//                     @"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],
//                     @"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],
//                     @"_userid_",[[CourierInfoManager shareInstance] getCourierPid],
//                     @"type",@"2",
//                     @"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
//    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                  @"ios",@"BaseAppType",
//                                  @"1.2.1",@"BaseAppVersion",
//                                  [NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",
//                                  @"1.2.1",@"BaseAppVersion",
//                                  [MyMD5 md5:str],@"_sign_",
//                                  [MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",
//                                  [[CourierInfoManager shareInstance] getCourierPid],@"_userid_",
//                                  @"2",@"type",
//                                  [[CourierInfoManager shareInstance] getCourierPid],@"userid",
//                                  nil];
    
    
//    NSDictionary *dic = @{@"BaseAppType":@"ios",
//                          @"BaseAppVersion":@"1.2.1",
//                          @"SystemVersion":@"iPhone_9.20",
//                          @"_sign_":@"c878fa183fa808ac50a8e43738a06445",
//                          @"car_type":@"3",
//                          @"card_opposite_image":@"/var/mobile/Containers/Data/Application/911BCF1F-74E9-4569-831D-E2EEC75CDFB2/tmp/headico.png",
//                          @"card_positive_image":@"/var/mobile/Containers/Data/Application/911BCF1F-74E9-4569-831D-E2EEC75CDFB2/tmp/headico.png",
//                          @"driving_image":@"/var/mobile/Containers/Data/Application/911BCF1F-74E9-4569-831D-E2EEC75CDFB2/tmp/headico.png",
//                          @"identity_card":@"612429196606296086",
//                          @"password":@"e10adc3949ba59abbe56e057f20f883e",
//                          @"phone":@"18888888888",
//                          @"username":@"哈哈哈",
//                          @"vehicle_image":@"/var/mobile/Containers/Data/Application/911BCF1F-74E9-4569-831D-E2EEC75CDFB2/tmp/headico.png"};
    
    
    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
//    [session POST:@"http://mapi.tzouyi.com/account/addpapply" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
    
}


#pragma mark -----网络请求-----
// 需填单请求
- (void)requestNeedWriteData {
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":@"0", @"num":@"100" ,@"type":@"2"}];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":paramterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = responseObject[@"status"];
            if (result.integerValue) {
                NSLog(@"失败");
            } else {
                NSLog(@"成功");
                NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                NSLog(@"dataDic = %@",dataDic);
                [self.needWriteArray removeAllObjects];
                for (NSDictionary *dic in dataDic[@"orderlist"]) {
                    BaseModel *model = [[BaseModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.needWriteArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    HomePageItemView *xutiandan = [self.homePageView viewWithTag:1002];
                    if (self.needWriteArray.count) {
                        xutiandan.rightMark.hidden = NO;
                    } else {
                        xutiandan.rightMark.hidden = YES;
                    }
                    
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    }
    
    
    
}

// 配送中请求
- (void)requestDeliveryData {
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":@"0", @"num":@"20" ,@"type":@"1"}];
        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":paramterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = responseObject[@"status"];
            if (result.integerValue) {
                NSLog(@"失败");
            } else {
                NSLog(@"成功");
                [self.deliveryArray removeAllObjects];
                NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                NSLog(@"dataDic = %@",dataDic);
                for (NSDictionary *dic in dataDic[@"orderlist"]) {
                    DeliveryModel *model = [[DeliveryModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.deliveryArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    HomePageItemView *peisongzhong = [self.homePageView viewWithTag:1001];
                    if (self.deliveryArray.count) {
                        peisongzhong.rightMark.hidden = NO;
                    } else {
                        peisongzhong.rightMark.hidden = YES;
                    }
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    }
    
}





// 上下班
- (void)work {
    NSLog(@"上班下班");
    
//    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
//    MainTabBarController *tabVC = (MainTabBarController *)appdelegate.window.rootViewController;
    
    self.isWork = !self.isWork;
    NSString *parameterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"isWork", @"is_online":[NSString stringWithFormat:@"%d",self.isWork],@"version":@"1",@"pid":[[CourierInfoManager shareInstance] getCourierPid], @"phone":[[CourierInfoManager shareInstance] getCourierPhone]}];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"data = %@",[EncryptionAndDecryption decryptionWithString:responseObject[@"data"]]);
        if (![responseObject[@"status"] integerValue]) {
            NSLog(@"成功");
        } else {
            NSLog(@"失败");
            self.isWork = !self.isWork;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isWork) {// 1在线
                [self.workBtn setBackgroundImage:[UIImage imageNamed:@"work"] forState:UIControlStateNormal];
                self.courierAddress.text = @"上班中，正在定位";
//                tabVC.tabdelegate = self;
            } else {// 0离线
                [self.workBtn setBackgroundImage:[UIImage imageNamed:@"workout"] forState:UIControlStateNormal];
                self.courierAddress.text = @"下班了";
//                tabVC.tabdelegate = nil;
            }
            [[CourierInfoManager shareInstance] saveCourierOnlineStatus:[NSString stringWithFormat:@"%d",self.isWork]];
            
            // 如果是在线状态使用别名标识设备
            if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
                [JPUSHService setAlias:[NSString stringWithFormat:@"puser_%@",[[CourierInfoManager shareInstance] getCourierPid]] callbackSelector:nil object:nil];
            } else {// 不在线
                [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}

// 给每个item添加block实现
- (void)addBlockAchive {
    HomePageItemView *daijiedan = [self.homePageView viewWithTag:1000];
    daijiedan.clickBlock = ^ () {
        NSLog(@"待接单");
        WaitOrderReceivingViewController *waitVC = [[WaitOrderReceivingViewController alloc] init];
        [self.navigationController pushViewController:waitVC animated:YES];
    };// 待接单
    HomePageItemView *peisongzhong = [self.homePageView viewWithTag:1001];
    peisongzhong.clickBlock = ^() {
        NSLog(@"配送中");
        DeliveryViewController *deliveryVC = [[DeliveryViewController alloc] init];
        [self.navigationController pushViewController:deliveryVC animated:YES];
    };// 配送中
    HomePageItemView *xutiandan = [self.homePageView viewWithTag:1002];
    xutiandan.clickBlock = ^ () {
        NSLog(@"需填单");
        NeedWriteViewController *needVC = [[NeedWriteViewController alloc] init];
        [self.navigationController pushViewController:needVC animated:YES];
        
    };// 需填单
    HomePageItemView *dengdaishenhe = [self.homePageView viewWithTag:1003];
    dengdaishenhe.clickBlock = ^ () {
        NSLog(@"等待审核");
        CheckingViewController *checkingVC = [[CheckingViewController alloc] init];
        [self.navigationController pushViewController:checkingVC animated:YES];
    };// 等待审核
    HomePageItemView *yiwancheng = [self.homePageView viewWithTag:1004];
    yiwancheng.clickBlock = ^() {
        NSLog(@"已完成");
        AlreadyDoneViewController *alreadyVC = [[AlreadyDoneViewController alloc] init];
        [self.navigationController pushViewController:alreadyVC animated:YES];
    };// 已完成
    HomePageItemView *jinritongji = [self.homePageView viewWithTag:1005];
    jinritongji.clickBlock = ^() {
        NSLog(@"todayDone");
        TodayInfoViewController *todayVC = [[TodayInfoViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    };// 今日统计
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

//
//  PersonViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PersonViewController.h"
#import "ClearView.h"
#import "AppraiseRateView.h"
#import "HeartAppraiseRateView.h"
#import "CourierInfoModel.h"
#import "LoginViewController.h"
#define kTFMargin 20

@interface PersonViewController ()

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) CourierInfoModel *courierInfoModel;

@end

@implementation PersonViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
//    NSNumber *pid = [NSNumber numberWithInteger:.integerValue];
//    NSLog(@"%@",[pid class]);
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    // 网络请求获取数据
    [self requestCourierInfo];

    
    
}

- (void)requestCourierInfo {
    // 创建参数字符串
    NSString *parameterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"myinfo", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid]}];
    //    {"api":"loginCourier","is_online":false,"class":"isWork","pid":"1","version":"1"}
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        // 将获取到的data字符串数据转化成字典
        NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
        NSLog(@"dataDic = %@", dataDic);
        self.courierInfoModel = nil;
        self.courierInfoModel = [[CourierInfoModel alloc] init];
        [self.courierInfoModel setValuesForKeysWithDictionary:dataDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 获取数据之后创建视图
            [self createView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

// 创建视图
- (void)createView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KTabBarHeight)];
//    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    // logo
    CGFloat logoWidth = 65 * kScaleForWidth;
    CGFloat logoHeight = logoWidth;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - logoWidth) * 0.5, logoWidth, logoWidth, logoHeight)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [scrollView addSubview:logoImageView];
    
    //    ClearView *testView = [[ClearView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    ////    testView.backgroundColor = [UIColor blueColor];
    //    [self.view addSubview:testView];
    
    // 用户名
    UIFont *usernameFont = [UIFont systemFontOfSize:20];
    self.userName = [[CourierInfoManager shareInstance] getCourierAlias];
    CGFloat usernameW = [UILabel getWidthWithTitle:self.userName
                                              font:usernameFont];
    CGFloat usernameH = [UILabel getHeightWithTitle:self.userName font:usernameFont];
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - usernameW) * .5, logoImageView.y + logoHeight + 10, usernameW, usernameH)];
    usernameLabel.text = self.userName;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.font = usernameFont;
//    usernameLabel.backgroundColor = [UIColor redColor];
    [scrollView addSubview:usernameLabel];
    
    // 总好评率
    CGFloat totalRate = self.courierInfoModel.zscore.floatValue / 5.0;// 好评率
    NSString *totalRateStr = [NSString stringWithFormat:@"总好评率%%%02.0f",totalRate * 100];
    UIFont *totalRateFont = [UIFont systemFontOfSize:13];
    CGFloat totalRateW = [UILabel getWidthWithTitle:totalRateStr font:totalRateFont];
    CGFloat totalRateH = [UILabel getHeightWithTitle:totalRateStr font:totalRateFont];
    UILabel *totalRateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - totalRateW) * .5, usernameLabel.y + usernameH + 5, totalRateW, totalRateH)];
    totalRateLabel.text = totalRateStr;
    totalRateLabel.font = totalRateFont;
    [scrollView addSubview:totalRateLabel];
    
    // 总好评率视图
    HeartAppraiseRateView *heartRateView = [[HeartAppraiseRateView alloc] initWithFrame:CGRectMake((kScreenWidth - kHeartWidth * 5) * .5, totalRateLabel.y + totalRateH + 10, kHeartWidth * 5, kHeartHeight) goodRate:totalRate];
    [scrollView addSubview:heartRateView];
    
    
    // 配送速度
    CGFloat speedRate = self.courierInfoModel.zspeed.floatValue / 5.0;
    AppraiseRateView *speedView = [[AppraiseRateView alloc] initWithFrame:CGRectMake(0, heartRateView.y + heartRateView.height + 20 * kScaleForHeight, kScreenWidth, 130) goodRate:speedRate title:@"配送速度"];
    
    [scrollView addSubview:speedView];
    
    // 服务态度
    CGFloat attitudeRate = self.courierInfoModel.zservice.floatValue / 5.0;
    AppraiseRateView *attitudeView = [[AppraiseRateView alloc] initWithFrame:CGRectMake(0, speedView.y + speedView.height - 20.0 / (kScaleForHeight), kScreenWidth, 130) goodRate:attitudeRate title:@"服务态度"];
    [scrollView addSubview:attitudeView];
    
    // 退出登录按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(kTFMargin, attitudeView.y + attitudeView.height + 20, kScreenWidth - kTFMargin * 2, 40 * kScaleForHeight);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00]];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.layer.cornerRadius = logoutBtn.height * 0.45;// 设置圆角效果
    logoutBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设                                                                                                                                                                                                                                                                                             置阴影颜色
    logoutBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    logoutBtn.layer.shadowOpacity = .5;// 阴影透明度
    logoutBtn.layer.shadowRadius = 4;// 阴影半径
    [scrollView addSubview:logoutBtn];
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, logoutBtn.y + logoutBtn.height + 20);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 测试
//    self.userName = [[CourierInfoManager shareInstance] getCourierAlias];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    
    

}

- (void)logout {
    /*
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确认要退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {// 退出登录时当在线状态为在线时改成下班状态
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
                        [self presentViewController:loginVC animated:YES completion:nil];
                    });
                } else {
                    NSLog(@"失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error is %@",error);
            }];
        }
        
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:confirm];
    [alertC addAction:cancel];
    
    [self presentViewController:alertC animated:YES completion:nil];
    */
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"确认要退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (buttonIndex == 1) {
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
                        [self presentViewController:loginVC animated:YES completion:nil];
                    });
                } else {
                    NSLog(@"失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error is %@",error);
            }];
        }
    }
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

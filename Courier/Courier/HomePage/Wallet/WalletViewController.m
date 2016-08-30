//
//  WalletViewController.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "WalletViewController.h"
#import "MissionViewController.h"
#import "OrderDetailInfoVC.h"
#import "MyDiscountVC.h"
#import "CommitCashVC.h"
#import "BankViewController.h"

@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self TixianYuLanData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"钱包";
//    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 返回按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:@"账单详情" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击查看货款明细"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] range:strRange];
    [self.selectBtn setAttributedTitle:str forState:UIControlStateNormal];
    
}


//提现预览
- (void)TixianYuLanData
{
    //http://client.local.courier.net/finance/prewwithdrawals 提现预览接口
    //    http://client.local.courier.net/finance/prewwithdrawals 提现预览接口
    //
    //    {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12"}
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.0.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.0.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session POST:@"http://mapi.tzouyi.com/finance/prewwithdrawals" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"success"])
        {
            self.priceLab.text = [NSString stringWithFormat:@"¥%@",[[responseObject objectForKey:@"data"] objectForKey:@"amount"]];
            
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"bank_name"] length] == 0)
            {
                BankViewController *VC = [[BankViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
        
    }];
}

- (IBAction)selectInfoBtnClick:(UIButton *)sender
{
    MissionViewController *VC = [[MissionViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)selectDetailBtnClick:(UIButton *)sender
{
    MyDiscountVC *VC = [[MyDiscountVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)commitBtnClick:(UIButton *)sender
{
    CommitCashVC *VC = [[CommitCashVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)rightItem
{
    OrderDetailInfoVC *VC = [[OrderDetailInfoVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

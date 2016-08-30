//
//  BankViewController.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BankViewController.h"
#import "BankCardListVC.h"

@interface BankViewController ()<BankNameDelegate>
{
    NSDictionary *_bankInfoDict;
}

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *belongToBankTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;

@end

@implementation BankViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"绑定银行卡";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.commitBtn.layer.cornerRadius = 18;
    self.commitBtn.clipsToBounds = YES;
    
    
}

- (void)requstData
{
//http://client.local.courier.net/finance/bindBank 绑定银行卡接口
//    {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12","userid":"12", "account_name":"张三","bank_id":"1","branch_name":"宝山分行","bank_card":"111111212121212"}
//    user_id         跑腿人ID
//    account_name 开户人名称
//    bank_id             所属银行ID
//    branch_name         分行名称
//    bank_card           开户人卡号
//    BaseAppType 系统类型：android 安卓 ios 苹果
//    BaseAppVersion App版本号【三位计算，比如：1.0.0】
//    SystemVersion 系统版本号
//    _sign_ 签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
//    _token_ 用户登录TOKEN 【md5（小写（用户ID+secretKey））】
//    _userid_ 用户ID
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"account_name",self.nameTF.text,@"bank_card",self.cardNumTF.text,@"bank_id",[_bankInfoDict objectForKey:@"id"],@"branch_name",self.bankNameTF.text,@"type",@"2",@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",self.nameTF.text,@"account_name",self.cardNumTF.text,@"bank_card",[_bankInfoDict objectForKey:@"id"],@"bank_id",self.bankNameTF.text,@"branch_name",@"2",@"type",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/finance/bindBank" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"success"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
        
    }];
}
- (IBAction)chooseBankButtonClick:(UIButton *)sender
{
    BankCardListVC *VC = [[BankCardListVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)tieCardButtonClick:(UIButton *)sender
{
    [self requstData];
}

- (void)setBankNameActionWithDict:(NSDictionary *)bankDic
{
    self.belongToBankTF.text = [bankDic objectForKey:@"name"];
    _bankInfoDict = bankDic;
}

@end

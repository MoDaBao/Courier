//
//  CommitCashVC.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CommitCashVC.h"

@interface CommitCashVC ()<UIAlertViewDelegate>
{
    NSString *_tixianMoney;
}

@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *SCTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *SCPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *BCPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *BCTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *waitAccountLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *daozhangTimeLab;


@end

@implementation CommitCashVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self TixianYuLanData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"提现";
//    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.commitBtn.layer.cornerRadius = 18;
    self.commitBtn.clipsToBounds = YES;
    
    self.cView.layer.borderWidth = 1;
    self.cView.layer.borderColor = [UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1].CGColor;
    self.cView.clipsToBounds = YES;
    
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
            self.nameLab.text = [NSString stringWithFormat:@"姓名：%@",[[responseObject objectForKey:@"data"] objectForKey:@"account_name"]];
            self.bankLab.text = [NSString stringWithFormat:@"银行：%@",[[responseObject objectForKey:@"data"] objectForKey:@"bank_name"]];
            self.carNumberLab.text = [NSString stringWithFormat:@"卡号：%@",[[responseObject objectForKey:@"data"] objectForKey:@"bank_card"]];
            self.daozhangTimeLab.text = [NSString stringWithFormat:@"预计到账时间：%@",[[responseObject objectForKey:@"data"] objectForKey:@"arrival_time"]];
            
            self.SCTimeLab.text = [NSString stringWithFormat:@"上次提现时间：%@",[[responseObject objectForKey:@"data"] objectForKey:@"last_time"]];
            self.SCPriceLab.text = [NSString stringWithFormat:@"上次提现金额：%@",[[responseObject objectForKey:@"data"] objectForKey:@"last_amount"]];
            
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次可提现金额：%@ ＋%@%@",[[responseObject objectForKey:@"data"] objectForKey:@"amount"],[[responseObject objectForKey:@"data"] objectForKey:@"task_amount"],[[responseObject objectForKey:@"data"] objectForKey:@"task_tips"]]];
            
            NSString *sss = [[responseObject objectForKey:@"data"] objectForKey:@"amount"];
            _tixianMoney = [[responseObject objectForKey:@"data"] objectForKey:@"amount"];
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8 + [sss length])];
            [self.BCPriceLab setAttributedText:noteStr] ;
            
            
//            self.BCPriceLab.text = [NSString stringWithFormat:@"本次可提现金额：%@ ＋%@%@",[[responseObject objectForKey:@"data"] objectForKey:@"amount"],[[responseObject objectForKey:@"data"] objectForKey:@"task_amount"],[[responseObject objectForKey:@"data"] objectForKey:@"task_tips"]];
            
            
            self.BCTimeLab.text = [[responseObject objectForKey:@"data"] objectForKey:@"tips"];
            self.waitAccountLab.text = [NSString stringWithFormat:@"待结算金额：%@（当日货款不可提现）",[[responseObject objectForKey:@"data"] objectForKey:@"confirm_amount"]];
            
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"amount"] floatValue] == 0.00)
            {
                self.bottomView.hidden = YES;
                self.commitBtn.hidden = YES;
            }
            else
            {
                self.bottomView.hidden = NO;
                self.commitBtn.hidden = NO;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
        
    }];
}


// 申请提现
- (void)shenqingtixian {
    /*
     申请提现
{"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"cc48d092a5f0a43bb3c6e74b31bbd4f9","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12","userid":"12","amount":"1.00"}
     BaseAppType 系统类型：android 安卓 ios 苹果
     BaseAppVersion App版本号【三位计算，比如：1.0.0】
     SystemVersion 系统版本号
     _sign_ 签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
     _token_ 用户登录TOKEN 【md5（小写（用户ID+secretKey））】
     _userid_ 用户ID
     userid      用户ID
     amount     提现金额
     */
    
    NSString *token = [MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]];
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType", @"ios", @"BaseAppVersion", @"1.0.1", @"SystemVersion", [NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]], @"_token_", token, @"_userid_", [[CourierInfoManager shareInstance] getCourierPid],@"amount", _tixianMoney,@"bonus_amount",@"0.00", @"userid", [[CourierInfoManager shareInstance] getCourierPid], @"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSString *sign = [MyMD5 md5:str];
    
    NSDictionary *dic = @{
                          @"BaseAppType":@"ios",
                          @"BaseAppVersion":@"1.0.1",
                          @"bonus_amount":@"0.00",
                          @"SystemVersion":[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],
                          @"_sign_":sign,
                          @"_token_":token,
                          @"_userid_":[[CourierInfoManager shareInstance] getCourierPid],
                          @"userid":[[CourierInfoManager shareInstance] getCourierPid],
                          @"amount":_tixianMoney
                          };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/finance/withdrawals" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"100002"])
        {
            [self showAlertWithMsg:[responseObject objectForKey:@"message"]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)commitButtonClick:(UIButton *)sender
{
    [self shenqingtixian];
}

- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end

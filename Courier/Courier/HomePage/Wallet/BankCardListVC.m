//
//  BankCardListVC.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/26.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BankCardListVC.h"
#import "CarListCell.h"
#import "BankViewController.h"

@interface BankCardListVC ()<UITableViewDelegate,UITableViewDataSource,BankNameDelegate>
{
    __weak IBOutlet UITableView *_table;
    NSArray *_dataArray;
}
@end

@implementation BankCardListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self yinhangkaliebiao];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"银行卡列表";
//    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    BankViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.childViewControllers.count - 2];
    self.bankNameDelegate = VC;
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 银行卡列表
- (void)yinhangkaliebiao {
    /*
     http://client.local.courier.net/finance/getbanklist     所属银行卡列表接口
     {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12"}
     BaseAppType 系统类型：android 安卓 ios 苹果
     BaseAppVersion App版本号【三位计算，比如：1.0.0】
     SystemVersion 系统版本号
     _sign_ 签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
     _token_ 用户登录TOKEN 【md5（小写（用户ID+secretKey））】
     _userid_ 用户ID
     
     */
    
    NSString *token = [MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]];
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType", @"ios", @"BaseAppVersion", @"1.0.1", @"SystemVersion", [NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]], @"_token_", token, @"_userid_", [[CourierInfoManager shareInstance] getCourierPid], @"userid",[[CourierInfoManager shareInstance] getCourierPid], @"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSString *sign = [MyMD5 md5:str];
    
    NSDictionary *dic = @{
                          @"BaseAppType":@"ios",
                          @"BaseAppVersion":@"1.0.1",
                          @"SystemVersion":[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],
                          @"_sign_":sign,
                          @"_token_":token,
                          @"_userid_":[[CourierInfoManager shareInstance] getCourierPid],
                          @"userid":[[CourierInfoManager shareInstance] getCourierPid]
                          //                          @"amount":@"10"
                          };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/finance/getbanklist" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"success"])
        {
            _dataArray = [responseObject objectForKey:@"data"];
            [_table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_1"];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CarListCell" owner:nil options:nil];
        cell = array[0];
    }
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"logo"]]];
    cell.bankNameLab.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.bankNameDelegate respondsToSelector:@selector(setBankNameActionWithDict:)])
    {
        [self.bankNameDelegate setBankNameActionWithDict:[_dataArray objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

//
//  OrderDetailInfoVC.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "OrderDetailInfoVC.h"
#import "OrderDetailCell.h"

@interface OrderDetailInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *_table;
    NSArray *_dataArray;
}



@end

@implementation OrderDetailInfoVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self zhangdanmingxi];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"账单明细";
//    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    _table.rowHeight = 80;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = [UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1];
    _table.rowHeight = 71;
}

- (void)zhangdanmingxi {
    /*
     账单明细
     BaseAppType	系统类型：android 安卓 ios 苹果
     BaseAppVersion	App版本号【三位计算，比如：1.0.0】
     SystemVersion	系统版本号
     _sign_		签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
     _token_		用户登录TOKEN 【md5（小写（用户ID+secretKey））】
     _userid_	用户ID
     userid      用户ID
     page_no		当前第一页
     page_size	每页显示数
     user_type   用户类型[0.用户,1.跑腿人]
     bill_type   账单类型[1、跑腿费，2、货到付款，3、在线支付货款，4、提现，5、红包,不传则表示全部]
     
     */
    NSString *token = [MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]];
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType", @"ios", @"BaseAppVersion", @"1.0.1", @"SystemVersion", [NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]], @"_token_", token, @"_userid_", [[CourierInfoManager shareInstance] getCourierPid],  @"page_no", @"1", @"page_size", @"1", @"user_type", @"1", @"userid", [[CourierInfoManager shareInstance] getCourierPid], @"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSString *sign = [MyMD5 md5:str];
    NSDictionary *dic = @{
                          @"BaseAppType":@"ios",
                          @"BaseAppVersion":@"1.0.1",
                          @"SystemVersion":[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],
                          @"_sign_":sign,
                          @"_token_":token,
                          @"_userid_":[[CourierInfoManager shareInstance] getCourierPid],
                          @"userid":[[CourierInfoManager shareInstance] getCourierPid],
                          @"page_no":@"1",
                          @"page_size":@"1",
                          @"user_type":@"1"
                          //                          @"bill_type":@""
                          };
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/finance/billLists" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"success"])
        {
            _dataArray = [[responseObject objectForKey:@"data"] objectForKey:@"datalist"];
            [_table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.paotuiLab.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"bill_name"];
    cell.priceLab.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"order_balance"];
    cell.timeLab.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"create_time"];
    cell.disPriceLab.text = [NSString stringWithFormat:@"余额%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"account_balance"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

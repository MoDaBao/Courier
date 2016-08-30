//
//  MissionViewController.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MissionViewController.h"
#import "MissionCell.h"

@interface MissionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_table;
    NSArray *_dataArray;
}
@end

@implementation MissionViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"补贴任务表";
    self.navigationController.navigationBar.hidden = NO;
//    [self requestData];
    [self requstData2];
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
    _table.rowHeight = 80;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//没有注释的接口
- (void)requestData {

//http://client.local.courier.net/account/checkBindCard
//    {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12"}
//    BaseAppType 系统类型：android 安卓 ios 苹果
//    BaseAppVersion App版本号【三位计算，比如：1.0.0】
//    SystemVersion 系统版本号
//    _sign_ 签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
//    _token_ 用户登录TOKEN 【md5（小写（用户ID+secretKey））】
//    _userid_ 用户ID
//    userid   用户ID
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/account/checkBindCard" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
        
    }];
    
}


//红包任务接口
- (void)requstData2
{
//http://client.local.courier.net/task/bonusLists 红包任务接口
//    {"BaseAppType":"android","BaseAppVersion":"1.2.1","SystemVersion":"4.4.4","_sign_":"c4161a4eecf435d6490e2d5c1770f261","_token_":"ec7b8d2b9f42bda73d461cea0845399d","_userid_":"12"}
//    BaseAppType 系统类型：android 安卓 ios 苹果
//    BaseAppVersion App版本号【三位计算，比如：1.0.0】
//    SystemVersion 系统版本号
//    _sign_  签名方式【key=value&key1=value1…&key=secretKey】从小到大排序，然后md5
//    _token_  用户登录TOKEN 【md5（小写（用户ID+secretKey））】
//    _userid_ 用户ID
//    userid   用户ID
    
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://mapi.tzouyi.com/task/bonusLists" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"success"])
        {
            _dataArray = [[responseObject objectForKey:@"data"] objectForKey:@"datalist"];
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
    MissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissionCell"];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MissionCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentLab.text = [NSString stringWithFormat:@"超过%@单 补贴%@元",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"order_num"],[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"subsidy_balance"]];
    cell.detContLab.text = [NSString stringWithFormat:@"（需要注册%@天以上）",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"register_days"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:245/255.0 alpha:1];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *labe = [[UILabel alloc] init];
    labe.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:245/255.0 alpha:1];
    labe.text = @"【提示】所有补贴的钱系统按照完成任务自动发放";
    labe.textAlignment = 1;
    labe.font = [UIFont systemFontOfSize:11.0];
    return labe;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

//
//  DeliveryViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DeliveryViewController.h"
#import "DeliveryTableViewCell.h"
#import "DeliveryModel.h"
#import "DeliveryDefaultTableViewCell.h"
#import "MessageBarButton.h"
#import "OrderDetailViewController.h"

@interface DeliveryViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, DeliveryDefaultTableViewCellDelegate, DeliveryTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *status;

@end

@implementation DeliveryViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

// 配送中请求 下来刷新
- (void)requestData {
    self.start = 0;
    NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":@"0", @"num":@"20" ,@"type":@"1"}];
    NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":paramterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
//        self.pickBtn.userInteractionEnabled = YES;
        if (result.integerValue) {
            NSLog(@"失败");
        } else {
            NSLog(@"成功");
            [self.dataArray removeAllObjects];
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"dataDic = %@",dataDic);
            if (dataDic.count) {// 当请求回来的数据条数为0的时候 页数不往下加
                self.start ++;
            }
            for (NSDictionary *dic in dataDic[@"orderlist"]) {
                DeliveryModel *model = [[DeliveryModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshing];
                if (self.dataArray.count) {
                    self.tableView.mj_footer.hidden = NO;
                } else {
                    self.tableView.mj_footer.hidden = YES;
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}

// 配送中请求 上拉加载
- (void)requestLoadData {
    
    NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":[NSString stringWithFormat:@"%ld",self.start], @"num":@"20" ,@"type":@"1"}];
    NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":paramterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.integerValue) {
            NSLog(@"失败");
        } else {
            NSLog(@"成功");
            [self.dataArray removeAllObjects];
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"dataDic = %@",dataDic);
            
            for (NSDictionary *dic in dataDic[@"orderlist"]) {
                DeliveryModel *model = [[DeliveryModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            if (dataDic.count) {
                self.start ++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    if (self.dataArray.count) {
        self.tableView.mj_footer.hidden = NO;
    } else {
        self.tableView.mj_footer.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
//    [self requestData];
    
    self.navigationItem.title = @"配送中";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.start = 0;
    self.num = 1;
    
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];// 上拉刷新
    // Enter the refresh status immediately
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];// 下拉加载
    self.tableView.mj_footer.hidden = YES;
//    [self.tableView.mj_footer beginRefreshing];
}

- (void)back {
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----TableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryModel *model = self.dataArray[indexPath.row];
    if ([model.start isEqualToString:@""] || [model.end isEqualToString:@""]) {
        return 260;
    }
    return 265;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    DeliveryModel *model = self.dataArray[indexPath.row];
    if ([model.start isEqualToString:@""] || [model.end isEqualToString:@""]) {
        DeliveryDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeliveryDefaultTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];// 设置cell的编号
        [cell setDataWithModel:model];
        return cell;
        
    } else {
        DeliveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeliveryTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];// 设置cell的编号
        [cell setDataWithModel:self.dataArray[indexPath.row]];
        
        return cell;
    }
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseModel *model = self.dataArray[indexPath.row];
    OrderDetailViewController *orderVC = [[OrderDetailViewController alloc] init];
    orderVC.baseModel = model;
    orderVC.isAlreadyDone = NO;
    orderVC.orderStatus = self.navigationItem.title;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
}


#pragma mark -----cell的Delegate-----
//  根据代理返回的message 和status字符串弹出提示框
- (void)refreshWithMessage:(NSString *)message status:(NSString *)status {
    
    self.status = status;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",message, status] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if ([self.status isEqualToString:@"成功"]) {
//        dispatch_after(2,dispatch_get_main_queue(), ^{
//            
//        });
        [self performSelector:@selector(refresh) withObject:self afterDelay:1];
        
    }
}

- (void)refresh {
    [self requestData];
}

- (void)defaultRefreshWithMessage:(NSString *)message status:(NSString *)status {
    [self refreshWithMessage:message status:status];
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

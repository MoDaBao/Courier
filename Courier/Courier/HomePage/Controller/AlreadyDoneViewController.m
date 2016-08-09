//
//  AlreadyDoneViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlreadyDoneViewController.h"
#import "AlreadyDoneTableViewCell.h"
#import "AlreadyDoneModel.h"
#import "AlreadyDoneDefaultTableViewCell.h"
#import "OrderDetailViewController.h"

@interface AlreadyDoneViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

//@property (nonatomic, strong) AlreadyDoneModel *alreadyModel;
@property (nonatomic, strong) NSMutableArray *dataArray;// 数据源

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger num;

@end

@implementation AlreadyDoneViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    
//    [self requestData];
}

// 已完成请求  下拉刷新
- (void)requestData {
    self.start = 0;
    NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":@"0", @"num":@"20" ,@"type":@"4"}];
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
            if (dataDic.count) {
                self.start ++;
            }
            for (NSDictionary *dic in dataDic[@"orderlist"]) {
                AlreadyDoneModel *model = [[AlreadyDoneModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            NSLog(@"self.dataArray = %@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
                
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

//  上拉加载
- (void)requestLoadData {
    NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":[NSString stringWithFormat:@"%ld",self.start], @"num":[NSString stringWithFormat:@"%ld",self.num] ,@"type":@"4"}];
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
            if (dataDic.count) {
                self.start ++;
            }
            for (NSDictionary *dic in dataDic[@"orderlist"]) {
                AlreadyDoneModel *model = [[AlreadyDoneModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            self.start ++;
            NSLog(@"self.dataArray = %@",self.dataArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self createView];// 创建视图
                [self.tableView reloadData];
//                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)createView {
    
    // 表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];// 下拉刷新
    // Enter the refresh status immediately
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];// 上拉加载
    [self.view addSubview:self.tableView];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationItem.title = @"已完成";
    
    [self createView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;// 给返回手势重新设置手势代理
    
    
    self.start = 0;
    self.num = 20;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (void)back {
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *resueIdentifier = @"resue";
    AlreadyDoneModel *model = self.dataArray[indexPath.row];
    if (![model.start isEqualToString:@""] || ![model.end isEqualToString:@""]) {
        AlreadyDoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resueIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AlreadyDoneTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];// 设置cell的编号
        [cell setDataWithModel:self.dataArray[indexPath.row]];// 给cell赋上模型的值
        return cell;
    } else {
//        Alread
        AlreadyDoneDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resueIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AlreadyDoneDefaultTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];// 设置cell的编号
        [cell setDataWithModel:model];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlreadyDoneModel *model = self.dataArray[indexPath.row];
    OrderDetailViewController *orderVC = [[OrderDetailViewController alloc] init];
    orderVC.baseModel = model;
    orderVC.isAlreadyDone = YES;
    orderVC.orderStatus = self.navigationItem.title;
    [self.navigationController pushViewController:orderVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 设置cell的背景色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
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

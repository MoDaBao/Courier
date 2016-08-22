//
//  NeedWriteViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NeedWriteViewController.h"
#import "BaseModel.h"
#import "NeedWriteOrderTableViewCell.h"
#import "WriteInfoViewController.h"

@interface NeedWriteViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger num;

@end

@implementation NeedWriteViewController

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
    
//    if (self.dataArray.count) {
////        self.tableView.mj_footer.hidden = NO;
//    } else {
//        self.tableView.mj_footer.hidden = YES;
//    }
    
}

// 需填单请求
- (void)requestData {
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        self.start = 0;
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
                NSLog(@"self.dataArray = %@",self.dataArray);
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in dataDic[@"orderlist"]) {
                    BaseModel *model = [[BaseModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                if (dataDic.count) {
                    self.start ++;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [self createView];// 创建视图
                    [self.tableView reloadData];
                    [self.tableView headerEndRefreshing];
                    //                [self.tableView.mj_footer endRefreshing];
                    //                if (self.dataArray.count) {
                    //                    self.tableView.mj_footer.hidden = NO;
                    //                } else {
                    //                    self.tableView.mj_footer.hidden = YES;
                    //                }
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableView headerEndRefreshing];
    }
    
    
    
}

// 需填单请求 上拉加载
- (void)requestLoadData {
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        NSString *paramterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"distribution", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"start":@"0", @"num":@"20" ,@"type":@"2"}];
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
                NSLog(@"self.dataArray = %@",self.dataArray);
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in dataDic[@"orderlist"]) {
                    BaseModel *model = [[BaseModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                if (dataDic.count) {
                    self.start ++;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [self createView];// 创建视图
                    [self.tableView reloadData];
                    //                [self.tableView.mj_header endRefreshing];
                    //                [self.tableView.mj_footer endRefreshing];
                    [self.tableView footerEndRefreshing];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableView footerEndRefreshing];
    }
    
   
    
}

- (void)createView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NeedWriteViewController *needVC = self;
    [self.tableView addHeaderWithCallback:^{
        [needVC requestData];
    }];
    [self.tableView headerBeginRefreshing];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    // Enter the refresh status immediately
//    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView addFooterWithCallback:^{
        [needVC requestLoadData];
    }];
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];
//    self.tableView.mj_footer.hidden = YES;
//    [self.tableView.mj_footer beginRefreshing];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"需填单";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
//    [self requestData];
    [self createView];
    
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
    return 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    BaseModel *model = self.dataArray[indexPath.row];
    NeedWriteOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NeedWriteOrderTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    [cell setDataWithMolde:model];
    cell.click = ^(void) {
        WriteInfoViewController *writeVC = [[WriteInfoViewController alloc] init];
        writeVC.baseModel = model;
        writeVC.refresh = ^ {
            [self requestData];
        };
        [self.navigationController pushViewController:writeVC animated:YES];
    };
    
    return cell;
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

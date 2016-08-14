//
//  WaitOrderReceivingViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "WaitOrderReceivingViewController.h"
#import "CallOutTableViewCell.h"
#import "WaitOrdrReceivingModel.h"
#import "WaitReceivingTableViewCell.h"
#import "ChatViewController.h"
#import "BaseModel.h"
#import "TipMessageView.h"

@interface WaitOrderReceivingViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) BaseModel *model;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WaitOrderReceivingViewController

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
//    if (_timer) {
//        [_timer setFireDate:[NSDate distantPast]];// 开启计时器
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (_timer) {
//        [_timer setFireDate:[NSDate distantFuture]];// 关闭计时器
//    }
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    // Enter the refresh status immediately
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.mj_footer.hidden = YES;
    
    if (!_isJPush) {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView.mj_footer beginRefreshing];
    }
    
    
    
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
    self.navigationItem.title = @"待接单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self createView];
    
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate distantFuture]];// 关闭计时器
    
    if (_isJPush) {
        [self requestJPushData];
//        [_timer setFireDate:[NSDate distantFuture]];
    }
    
   
    
}

- (void)refresh {
    [self requestData];
}

- (void)requestJPushData {
    NSDictionary *dic = @{@"api":@"pgetorder", @"version":@"1", @"order_sn":_order_sn};
    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSNumber *result = responseObject[@"status"];
        [self.dataArray removeAllObjects];
        if (!result.integerValue) {
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"dataDic = %@",dataDic);
            WaitOrdrReceivingModel *model = [[WaitOrdrReceivingModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic[@"orderlist"]];
            [self.dataArray insertObject:model atIndex:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//            [_timer setFireDate:[NSDate distantPast]];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)requestData {
    NSDictionary *dic = @{@"api":@"pgetorders", @"version":@"1", @"start":@"0", @"num":@"10"};
    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSNumber *result = responseObject[@"status"];
        [self.dataArray removeAllObjects];
        if (!result.integerValue) {
                        NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"dataDic = %@",dataDic);
            for (NSDictionary *dic in dataDic[@"orderlist"]) {
                WaitOrdrReceivingModel *model = [[WaitOrdrReceivingModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray insertObject:model atIndex:0];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitOrdrReceivingModel *model = self.dataArray[indexPath.row];
    if (!model.start.length) {
        return 200;
    } else {
        return 285;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    // 根据模型来选择cell样式
    WaitOrdrReceivingModel *model = self.dataArray[indexPath.row];
    if (!model.start.length) {
        CallOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CallOutTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setDataWithModel:self.dataArray[indexPath.row]];
        cell.orderRcceiving = ^(NSString * msg) {
            
            self.msg = msg;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            _indexPath = indexPath;
            _model = model;
            
            CGFloat margin = 100;
            CGFloat width = kScreenWidth - margin * 2;
            CGFloat height = 100;
            CGFloat tipY = (kScreenHeight - height) * .5;
            TipMessageView *tipView = [[TipMessageView alloc] initWithFrame:CGRectMake(margin, tipY, width, height) tip:msg];
            [self.view addSubview:tipView];
            
            [self.tableView.mj_header beginRefreshing];
            
        };
        //    cell.
        
        return cell;
    } else {
        WaitReceivingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitReceivingTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setDataWithModel:model];
        cell.orderRcceiving = ^(NSString * msg) {
            
            self.msg = msg;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            _model = model;
            
            // 提示框
            CGFloat margin = 100;
            CGFloat width = kScreenWidth - margin * 2;
            CGFloat height = 100;
            CGFloat tipY = (kScreenHeight - height) * .5;
            TipMessageView *tipView = [[TipMessageView alloc] initWithFrame:CGRectMake(margin, tipY, width, height) tip:msg];
            [self.view addSubview:tipView];
            
            [self.tableView.mj_header beginRefreshing];
            
        };
        return cell;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([_msg isEqualToString:@"接单成功"]) {// 接单成功
        if (_isJPush) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
        } else {
            [self requestData];
        }
        
        // 调出聊天页面
//        [self chat];
        
    } else {// 接单失败
        [self requestData];
    }
    
    
    
}

// 调出聊天界面
- (void)chat {
    
    //新建一个聊天会话View Controller对象ler alloc]init];
    //    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:self.baseModel];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:_model];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _model.order_sn;
    
    //设置聊天会话界面要显示的标题
    chatVC.title = _model.userphone;
    
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
}

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

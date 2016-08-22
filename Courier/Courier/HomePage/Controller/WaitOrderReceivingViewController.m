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
#import "TableHeaderView.h"

@interface WaitOrderReceivingViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, TableHeaderViewDelegate>
/**
 *  要填的单子的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  直接送的单子的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataA;
/**
 *  要填单的单子 表视图
 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TableHeaderView *fristView;
@property (nonatomic, strong) TableHeaderView *secondView;
///**
// *  直接送的单子  表视图
// */
//@property (nonatomic, strong) UITableView *table;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) BaseModel *model;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isNeedExpansion;// 需填单 是否展开
@property (nonatomic, assign) BOOL isExpansion;// 直接送 是否展开

@end

@implementation WaitOrderReceivingViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataA {
    if (!_dataA) {
        self.dataA = [NSMutableArray array];
    }
    return _dataA;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        if (_timer) {
            [_timer setFireDate:[NSDate distantPast]];// 开启计时器
        }
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];// 关闭计时器
    }
}

- (void)createView {
    
    /**
     加载需要填单的表视图
     */
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
//    [self.tableView registerClass:[WriteTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"reuse"];
//    [self.tableView registerClass:[TableHeaderView class] forHeaderFooterViewReuseIdentifier:@"reuse"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    WaitOrderReceivingViewController *waitVC = self;
    [self.tableView addHeaderWithCallback:^{
        [waitVC requestData];
    }];
    // Enter the refresh status immediately
    
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    self.tableView.mj_footer.hidden = YES;
    
    if (!_isJPush) {
//        [self.tableView.mj_header beginRefreshing];
        [self.tableView headerBeginRefreshing];
//        [self.tableView.mj_footer beginRefreshing];
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
    
    _isExpansion = NO;
    _isNeedExpansion = NO;
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate distantFuture]];// 关闭计时器
    
    if (_isJPush) {
        [self requestJPushData];
//        [_timer setFireDate:[NSDate distantFuture]];
    } else {
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
            [self requestData];
        }
        
    }
    
   
    
}

- (void)refresh {
    [self requestData];
}

- (void)requestJPushData {
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
        NSDictionary *dic = @{@"api":@"pgetorder", @"version":@"1", @"order_sn":_order_sn};
        NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            NSNumber *result = responseObject[@"status"];
            if (!result.integerValue) {
                [self.dataArray removeAllObjects];
                NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                NSLog(@"dataDic = %@",dataDic);
                WaitOrdrReceivingModel *model = [[WaitOrdrReceivingModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic[@"orderlist"]];
                if (model.type.integerValue == 3 || model.start.length == 0 || model.end.length == 0) {// 需要填单
                    [self.dataArray insertObject:model atIndex:0];
                } else {
                    [self.dataA insertObject:model atIndex:0];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //            [_timer setFireDate:[NSDate distantPast]];
                
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (void)requestData {
    
    if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
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
                [self.dataArray removeAllObjects];
                [self.dataA removeAllObjects];
                for (NSDictionary *dic in dataDic[@"orderlist"]) {
                    WaitOrdrReceivingModel *model = [[WaitOrdrReceivingModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (model.type.integerValue == 3 || model.start.length == 0 || model.end.length == 0) {// 需要填单
                        [self.dataArray insertObject:model atIndex:0];
                    } else {
                        [self.dataA insertObject:model atIndex:0];
                    }
                    
                }
                _isExpansion = NO;
                _isNeedExpansion = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //            [self.tableView.mj_header endRefreshing];
                [self.tableView headerEndRefreshing];
                //            [self.tableView.mj_footer endRefreshing];
                
                if (!_timer) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableView headerEndRefreshing];

    }
    
    
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

#pragma mark -----TableHeaderView代理方法-----

- (void)reloadTableViewWithExpansion:(BOOL)isExpansion tag:(NSInteger)tag view:(TableHeaderView *)view{
//    if (tag == 23333) {// 直接送的单子
//        _isExpansion = isExpansion;
//    } else {
//        _isNeedExpansion = isExpansion;
//    }
//    [self.tableView reloadData];
    
//    if (view == _fristView) {// 要填单
//        
//    }
    if (view == _fristView) {
         NSLog(@"2333333%@",view);
        _isNeedExpansion = isExpansion;
        if (isExpansion) {
            [_fristView.rightImage setImage:[UIImage imageNamed:@"djd_up"] forState:UIControlStateNormal];
            _fristView.expansion.text = @"(点击收起)";
        } else {
            [_fristView.rightImage setImage:[UIImage imageNamed:@"djd_down"] forState:UIControlStateNormal];
            _fristView.expansion.text = @"(点击展开)";
        }
    } else {
        _isExpansion = isExpansion;
        if (isExpansion) {
            [_secondView.rightImage setImage:[UIImage imageNamed:@"djd_up"] forState:UIControlStateNormal];
            _secondView.expansion.text = @"(点击收起)";
        } else {
            [_secondView.rightImage setImage:[UIImage imageNamed:@"djd_down"] forState:UIControlStateNormal];
            _secondView.expansion.text = @"(点击展开)";
        }
        NSLog(@"66666");
    }
    
    [self.tableView reloadData];
   
    
}

//- (void)headerChange {
//    
//}

#pragma mark -----表视图代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_isNeedExpansion) {// 展开
            return self.dataArray.count;
        } else {// 收起
            if (self.dataArray.count) {
                return 1;
            } else {
                return 0;
            }
        }
    } else {
        if (_isExpansion) {
            return self.dataA.count;
        } else {
            if (self.dataA.count) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WaitOrdrReceivingModel *model = self.dataArray[indexPath.row];
        if (!model.start.length) {
            return 200;
        } else {
            return 285;
        }
    } else {
        WaitOrdrReceivingModel *model = self.dataA[indexPath.row];
        if (!model.start.length) {
            return 200;
        } else {
            return 285;
        }
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
//        _fristView = nil;
        if (!_fristView) {
            _fristView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:@"要填单的单子"];
            _fristView.delegate = self;
        }
        return _fristView;
    } else if (section == 1) {
//        _secondView = nil;
        if (!_secondView) {
            _secondView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:@"直接送的单子"];
            _secondView.delegate = self;
        }
        return _secondView;
    } else {
        return nil;
    }
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    
    WaitOrdrReceivingModel *model = nil;
    // 根据模型来选择cell样式
    if (indexPath.section == 0) {
        model = self.dataArray[indexPath.row];
    } else {
        model = self.dataA[indexPath.row];
    }
    
    if (!model.start.length) {
        CallOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CallOutTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setDataWithModel:self.dataArray[indexPath.row]];
        cell.orderRcceiving = ^(NSString * msg) {
            
            self.msg = msg;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            _indexPath = indexPath;
            _model = model;
            
            CGFloat margin = 100;
            CGFloat width = kScreenWidth - margin * 2;
            CGFloat height = 100;
            CGFloat tipY = (kScreenHeight - height) * .5;
            TipMessageView *tipView = [[TipMessageView alloc] initWithFrame:CGRectMake(margin, tipY, width, height) tip:msg];
            [self.view addSubview:tipView];
            
//            [self.tableView.mj_header beginRefreshing];
            [self.tableView reloadData];
            
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            _model = model;
            
//            // 提示框
//            CGFloat margin = 100;
//            CGFloat width = kScreenWidth - margin * 2;
//            CGFloat height = 100;
//            CGFloat tipY = (kScreenHeight - height) * .5;
//            TipMessageView *tipView = [[TipMessageView alloc] initWithFrame:CGRectMake(margin, tipY, width, height) tip:msg];
//            [self.view addSubview:tipView];
            
//            [self.tableView.mj_header beginRefreshing];
            [self.tableView headerBeginRefreshing];
            
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
        [self chat];
        
    } else {// 接单失败
        [self requestData];
    }
    
    
    
}

// 调出聊天界面
- (void)chat {
    
    [NSThread sleepForTimeInterval:1.0f];
    
//    NSString *userid = [_model.userid substringFromIndex:1];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"orderinfo",@"api",@"1",@"version",_model.userid,@"userid",_model.order_sn,@"order_sn",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"equment",nil];
    NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dataDic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (!result.integerValue) {
            NSDictionary *data = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"%@",data);
            BaseModel *model = [[BaseModel alloc] init];
            [model setValuesForKeysWithDictionary:data[@"orderlist"][0]];
            _model = model;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
    
    
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

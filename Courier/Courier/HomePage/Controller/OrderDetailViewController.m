//
//  OrderDetailViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailDefaultTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "ChatViewController.h"
#import "MessageBarButton.h"
#import "PathPlaningMapViewController.h"
#import "OrderDetailDefaultBuyTableViewCell.h"
#import "OrderDetailBuyTableViewCell.h"
#import "FeHourGlass.h"

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FeHourGlass *hourGlass;

//@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MessageBarButton *message;

@end

@implementation OrderDetailViewController

//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        self.dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"订单详情";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    OrderDetailViewController *orderVC = self;
    if (!_isAlreadyDone) {
        // 消息rightBarItem
        _message = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"消息" font:[UIFont systemFontOfSize:13]];
        _message.click = ^ {
            // 这里要根据订单生成一个会话
            
            [orderVC chat];
            
            NSLog(@"点击了消息item");
            
        };
        UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_message];
        self.navigationItem.rightBarButtonItem = messageItem;
    }
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}

// 调出聊天界面
- (void)chat {
    
    //新建一个聊天会话View Controller对象ler alloc]init];
//    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:self.baseModel];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:_baseModel];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _baseModel.order_sn;
    
    //设置聊天会话界面要显示的标题
    chatVC.title = self.baseModel.userphone;
    
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)back {
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----TableView代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *note = _baseModel.note;
    if ([note isEqualToString:@""]) {
        note = @" ";
    }
    CGFloat noteH = [UILabel getHeightByWidth:kScreenWidth - 104 title:note font:[UIFont systemFontOfSize:14]];
    
    
    if (_isDelivery) {// 在配送中查看单子 需要留出配送按钮的高度
        if ([self.baseModel.start isEqualToString:@""] || [self.baseModel.end isEqualToString:@""]) {
            if (self.baseModel.type.integerValue == 3) {// 帮我买
                return 460 + noteH;
            } else {
                return 480 + noteH;
            }
            
        }
        if (self.baseModel.type.integerValue == 3) {
            return 480 + noteH;
        } else {
            return 500 + noteH;
        }
    } else {// 在不是配送中的页面查看单子
        if ([self.baseModel.start isEqualToString:@""] || [self.baseModel.end isEqualToString:@""]) {
            if (self.baseModel.type.integerValue == 3) {
                return 403 + noteH;
            } else {
                return 423 + noteH;
            }
        }
        if (self.baseModel.type.integerValue == 3) {
            return 423 + noteH;
        } else {
            return 443 + noteH;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifer = @"reuse";
    if ([self.baseModel.start isEqualToString:@""] || [self.baseModel.end isEqualToString:@""]) {
        if (_baseModel.type.integerValue != 3) {
            OrderDetailDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailDefaultTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // 设置数据
            [cell setDataWithModel:self.baseModel];
            cell.lookRouteLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultStartText"];
            cell.delegate = self;
            if (_orderStatus) {
                cell.checkLabel.text = _orderStatus;
            }
            
            if (_isDelivery) {
                cell.orderReceivingBtn.hidden = NO;
            } else {
                cell.orderReceivingBtn.hidden = YES;
            }
            if (_isAlreadyDone) {
                cell.checkLabel.text = @"已送达";
            }
//            cell.lookRoute = ^ {
//                PathPlaningMapViewController *pathVC = [[PathPlaningMapViewController alloc] init];
//                pathVC.baseModel = self.baseModel;
//                pathVC.isDefault = YES;
//                [self.navigationController pushViewController:pathVC animated:YES]
//                ;
//            };
            return cell;
        } else {
            OrderDetailDefaultBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailDefaultBuyTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // 设置数据
            [cell setDataWithModel:self.baseModel];
            cell.checkLabel.text = _orderStatus;
            cell.lookRouteLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultStartText"];
            cell.delegate = self;
//            cell.lookRoute = ^ {
//                PathPlaningMapViewController *pathVC = [[PathPlaningMapViewController alloc] init];
//                pathVC.baseModel = self.baseModel;
//                pathVC.isDefault = YES;
//                [self.navigationController pushViewController:pathVC animated:YES]
//                ;
//            };
            if (_isDelivery) {
                cell.orderReceivingBtn.hidden = NO;
            } else {
                cell.orderReceivingBtn.hidden = YES;
            }
            if (_isAlreadyDone) {
                cell.checkLabel.text = @"已送达";
            }
            return cell;
        }
    } else {
        if (_baseModel.type.integerValue != 3) {
            OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            // 设置cell数据
            [cell setDataWithModel:self.baseModel];
            cell.checkLabel.text = _orderStatus;
            cell.push = ^ {
                PathPlaningMapViewController *pathVC = [[PathPlaningMapViewController alloc] init];
                pathVC.baseModel = self.baseModel;
                pathVC.isDefault = NO;
                [self.navigationController pushViewController:pathVC animated:YES]
                ;
            };
            if (_isDelivery) {
                cell.orderReceivingBtn.hidden = NO;
            } else {
                cell.orderReceivingBtn.hidden = YES;
            }
            if (_isAlreadyDone) {
                cell.checkLabel.text = @"已送达";
            }
            return cell;
        } else {
            OrderDetailBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailBuyTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // 设置cell数据
            [cell setDataWithModel:self.baseModel];
            cell.checkLabel.text = _orderStatus;
            cell.push = ^ {
                PathPlaningMapViewController *pathVC = [[PathPlaningMapViewController alloc] init];
                pathVC.baseModel = self.baseModel;
                pathVC.isDefault = NO;
                [self.navigationController pushViewController:pathVC animated:YES]
                ;
            };
            cell.delegate = self;
            if (_isAlreadyDone) {
                cell.checkLabel.text = @"已完成";
            }
            if (_isDelivery) {
                cell.orderReceivingBtn.hidden = NO;
            } else {
                cell.orderReceivingBtn.hidden = YES;
            }
            return cell;
        }
    }
}


// 设置cell的背景色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
}

#pragma mark -----cell的Delegate-----

//  根据代理返回的message 和status字符串弹出提示框
- (void)orderDefaultRefreshWithMessage:(NSString *)message status:(NSString *)status; {
    
    self.status = status;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",message, status] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
    
    
}

- (void)orderRefreshWithMessage:(NSString *)message status:(NSString *)status {
    self.status = status;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",message, status] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)orderBuyRefreshWithMessage:(NSString *)message status:(NSString *)status {
    self.status = status;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",message, status] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)orderDefaultBuyRefreshWithMessage:(NSString *)message status:(NSString *)status {
    self.status = status;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",message, status] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if ([self.status isEqualToString:@"成功"]) {
        //        dispatch_after(2,dispatch_get_main_queue(), ^{
        //            [self refresh];
        //        });
        //        [self performSelector:@selector(refresh) withObject:self afterDelay:1];
        
        
        CGFloat height = 100;
        CGFloat width = 100;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - width) * .5, (kScreenHeight - kNavigationBarHeight - height) * .5, width, height)];
        
        _hourGlass = [[FeHourGlass alloc] initWithView:view];
        _hourGlass.frame = CGRectMake((kScreenWidth - width) * .5, (kScreenHeight - kNavigationBarHeight - height) * .5, width, height);
        _hourGlass.layer.cornerRadius = 8;
        //                    hourGlass.backgroundColor = [
        [self.view addSubview:_hourGlass];
        
        [_hourGlass showWhileExecutingBlock:^{
            [self myTask];
        } completion:^{
            [self refresh];
        }];
        //        _isRefresh = YES;
        
        
    }
}

- (void)myTask
{
    // Do something usefull in here instead of sleeping ...
    sleep(1);
}

- (void)refresh {
    [self requestData];
    NSLog(@"刷新数据");
    
}

- (void)requestData {
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"orderinfo",@"api",@"1",@"version",self.baseModel.userid,@"userid",_baseModel.order_sn,@"order_sn",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"equment",nil];
    NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dataDic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSNumber *result = responseObject[@"status"];
//        [self.dataArray removeAllObjects];
        if (!result.integerValue) {
            NSDictionary *data = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"%@",data);
            BaseModel *model = [[BaseModel alloc] init];
            [model setValuesForKeysWithDictionary:data[@"orderlist"][0]];
//            [self.dataArray insertObject:model atIndex:0];
            _baseModel = model;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [_timer setFireDate:[NSDate distantPast]];
            if (_hourGlass) {
                
                [_hourGlass removeFromSuperview];
                _hourGlass = nil;
            }
            
            if (_baseModel.status.integerValue == 5 || _baseModel.status.integerValue == 6) {
                _isDelivery = NO;
                _isAlreadyDone = YES;
//                self.navigationItem.rightBarButtonItem
                if (_message) {
                    _message.hidden = YES;
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(refreshDelivery)]) {
                [self.delegate refreshDelivery];
            }
            
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
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

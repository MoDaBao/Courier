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

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation OrderDetailViewController

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
    
    if (!_isAlreadyDone) {
        // 消息rightBarItem
        MessageBarButton *message = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"消息" font:[UIFont systemFontOfSize:13]];
        message.click = ^ {
            // 这里要根据订单生成一个会话
            
            [self chat];
            
            NSLog(@"点击了消息item");
            
        };
        UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:message];
        self.navigationItem.rightBarButtonItem = messageItem;
    }
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.baseModel.start isEqualToString:@""] || [self.baseModel.end isEqualToString:@""]) {
        return 448;
    }
    return 468;
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
            if (_orderStatus) {
                cell.checkLabel.text = _orderStatus;
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
//            cell.lookRoute = ^ {
//                PathPlaningMapViewController *pathVC = [[PathPlaningMapViewController alloc] init];
//                pathVC.baseModel = self.baseModel;
//                pathVC.isDefault = YES;
//                [self.navigationController pushViewController:pathVC animated:YES]
//                ;
//            };
            return cell;
        }
    } else {
        if (_baseModel.type.integerValue != 3) {
            OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailTableViewCell" owner:nil options:nil] lastObject];
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
            return cell;
        }
    }
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

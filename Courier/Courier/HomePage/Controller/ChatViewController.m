//
//  ChatViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/28.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ChatViewController.h"
#import "BaseModel.h"

#import "ChatListCell.h"
#import "TestMessageCell.h"
#import "SimpleMessageCell.h"
#import "OrderNoAddressView.h"
#import "OrderDefaultView.h"
#import "OrderView.h"
#import "OrderDetailViewController.h"
#import "WriteInfoViewController.h"

@interface ChatViewController ()<RCIMReceiveMessageDelegate, UIGestureRecognizerDelegate>



@end

@implementation ChatViewController

- (instancetype)initWithModel:(BaseModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

//  创建视图
- (void)createView {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(0, 0, 60, 20);
    [orderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *orderItem = [[UIBarButtonItem alloc] initWithCustomView:orderBtn];
    
    UIButton *dailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dailBtn.frame = CGRectMake(0, 0, 30, 20);
    [dailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dailBtn setTitle:@"拨号" forState:UIControlStateNormal];
    [dailBtn addTarget:self action:@selector(dail) forControlEvents:UIControlEventTouchUpInside];
    dailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *dailItem = [[UIBarButtonItem alloc] initWithCustomView:dailBtn];
    
    self.navigationItem.rightBarButtonItems = @[orderItem, dailItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationItem.title = self.model.userphone;
    
    [self.pluginBoardView removeItemAtIndex:2];
    
    [self createView];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    
    
    
//    [self.conversationMessageCollectionView registerNib:[UINib nibWithNibName:@"TestMessageCell" bundle:nil] forCellWithReuseIdentifier:@"reuse"];
    [self registerClass:[SimpleMessageCell class] forCellWithReuseIdentifier:@"SimpleMessageCell"];
    
    
    // 加载订单视图
    if (!_model.start.length || !_model.end.length) {
        if (!_model.start_latitude.length || !_model.end_latitude.length) {// 加载无地址的
            OrderNoAddressView *orderView = [[[NSBundle mainBundle] loadNibNamed:@"OrderNoAddressView" owner:nil options:nil] lastObject];
            self.conversationMessageCollectionView.y += orderView.height;
            self.conversationMessageCollectionView.height -= orderView.height;
//            orderView.backgroundColor = self.conversationMessageCollectionView.backgroundColor;
            [orderView setDataWithModel:_model];
            [self.view addSubview:orderView];
        } else {// 加载默认的
            OrderDefaultView *orderView = [[[NSBundle mainBundle] loadNibNamed:@"OrderDefaultView" owner:nil options:nil] lastObject];
            [orderView setDataWithModel:_model];
            [self.view addSubview:orderView];
            self.conversationMessageCollectionView.y += orderView.height;
            self.conversationMessageCollectionView.height -= orderView.height;
//            orderView.backgroundColor = self.conversationMessageCollectionView.backgroundColor;
        }
    } else {
        // 加载有地址的
        OrderView *orderView = [[[NSBundle mainBundle] loadNibNamed:@"OrderView" owner:nil options:nil] lastObject];
        [orderView setDataWithModel:_model];
        [self.view addSubview:orderView];
        self.conversationMessageCollectionView.y += orderView.height;
        self.conversationMessageCollectionView.height -= orderView.height;
//        orderView.backgroundColor = self.conversationMessageCollectionView.backgroundColor;
    }
    

    
    
//    self.conversationMessageCollectionView.delegate = self;
//    self.conversationMessageCollectionView.dataSource = self;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (void)order {
    if (_model.status.integerValue == 2 || _model.status.integerValue == 3 || _model.status.integerValue == 4 || _model.status.integerValue == 5 || _model.status.integerValue == 6 || _model.status.integerValue == 10) {
        OrderDetailViewController *orderVC = [[OrderDetailViewController alloc] init];
        orderVC.baseModel = _model;
        orderVC.isAlreadyDone = YES;
        //    orderVC.orderStatus = self.navigationItem.title;
        switch ([_model.status integerValue])
        {
            case 0:
                orderVC.orderStatus = @"未填单";
                break;
            case 1:
                orderVC.orderStatus = @"未填单";
                break;
            case 2:
                orderVC.orderStatus = @"已接单";
                break;
            case 3:
                orderVC.orderStatus = @"正在路上";
                break;
            case 4:
                orderVC.orderStatus = @"正在配送";
                break;
            case 5:
                orderVC.orderStatus = @"已送达";
                break;
            case 6:
                orderVC.orderStatus = @"已完成";
                break;
            case 7:
                orderVC.orderStatus = @"正在退款";
                break;
            case 8:
                orderVC.orderStatus = @"已取消";
                break;
            case 9:
                orderVC.orderStatus = @"未填单";
                break;
            case 10:
                orderVC.orderStatus = @"审核中";
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:orderVC animated:YES];
    } else {
        NSString *msg = nil;
        if (_model.status.integerValue == 10) {
//            msg = @"请等待用户审核";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            
            
        } else { // 跳转到填单页面
//            msg = @"请先填单";
            WriteInfoViewController *writeVC = [[WriteInfoViewController alloc] init];
            writeVC.baseModel = _model;
            writeVC.refresh = ^ {
                
            };
            [self.navigationController pushViewController:writeVC animated:YES];
        }
        
    }
    
    
}

- (void)dail {
    // 确认拨号
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_model.userphone]];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"%@",message.content.rawJSONData);
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//  即将显示cell的回调
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *msgCell = (RCTextMessageCell *)cell;
        msgCell.bubbleBackgroundView.backgroundColor = [UIColor whiteColor];
        msgCell.bubbleBackgroundView.layer.cornerRadius = 4;
        msgCell.bubbleBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        msgCell.bubbleBackgroundView.layer.borderWidth = 1;
        msgCell.bubbleBackgroundView.image = nil;
    }
}


- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString * cellIndentifier=@"SimpleMessageCell";
    RCMessageBaseCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier           forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回自定义cell的实际高度（这里请返回消息的实际大小）
    return CGSizeMake(300, 60);
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
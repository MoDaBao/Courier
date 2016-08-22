//
//  TestChatListViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TestChatListViewController.h"
#import "TestCell.h"
#import "ChatListCell.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "BaseModel.h"
#import "ChatListModel.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"

@interface TestChatListViewController ()<UIAlertViewDelegate>

/**
 *  后台请求数据数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  消息列表数据源
 */
@property (nonatomic, strong) NSMutableArray *chatListArray;

@property (nonatomic, strong) NSMutableArray *tempArr;

@property (nonatomic, strong) BaseModel *baseModel;


@end

@implementation TestChatListViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)chatListArray {
    if (!_chatListArray) {
        self.chatListArray = [NSMutableArray array];
    }
    return _chatListArray;
}

- (NSMutableArray *)tempArr {
    if (!_tempArr) {
        self.tempArr = [NSMutableArray array];
    }
    return _tempArr;
}



- (instancetype)init {
    if (self = [super init]) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
        //        [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
        [self requestData];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.conversationListTableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
//    self.conversationListTableView.separatorColor = [UIColor colorWithRed:193  / 255.0 green:26 / 255.0 blue:32 / 255.0 alpha:1.0];
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    backBtn.frame = CGRectMake(0, 0, 20, 20);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    
    self.navigationItem.title = @"消息列表";
    self.emptyConversationView.hidden = YES;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestData {
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"type",@"2",@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",@"1.2.1",@"BaseAppVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",@"2",@"type",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session POST:@"http://api.dev.yoguopin.com/order/userOrderList" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"success"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"][@"datalist"]) {
                BaseModel *model = [[BaseModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            NSLog(@"%@",self.dataArray);
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self willReloadTableData:_tempArr];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}





// push到会话页面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(ChatListModel *)model atIndexPath:(NSIndexPath *)indexPath {
//    ChatListModel *chat = self.chatListArray[indexPath.row];
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        TestChatListViewController *temp = [[TestChatListViewController alloc] init];
        [temp setDisplayConversationTypes:@[@(model.conversationType)]];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    } else if (model.conversationType == ConversationType_GROUP) {
        //        ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:nil];
        BaseModel *baseModel = nil;
        for (BaseModel *base in self.dataArray) {
            if ([base.order_sn isEqualToString:model.order_sn]) {
                baseModel = base;
            }
        }
        ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:baseModel];
        
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.order_sn;
        chatVC.title = model.userphone;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    
}



- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
//    model.conversationModelType=RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION
    
    NSLog(@"%@",dataSource);
//    RCConversationModel *a = [dataSource objectAtIndex:0];
    
//    [self.conversationListDataSource removeAllObjects];
    
    // 加载订单数据
//    [self requestDataWithDataArray:dataSource];
    
    _tempArr = dataSource;
    
    for (RCConversationModel *model in dataSource) {
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    }
    
    [self.chatListArray removeAllObjects];
    for (BaseModel *baseModel in self.dataArray) {
        ChatListModel *chat = [[ChatListModel alloc] init];
        chat.order_sn = baseModel.order_sn;
        chat.type = baseModel.type;
        chat.payment = baseModel.payment;
        chat.pay_status = baseModel.pay_status;
        chat.distance = baseModel.distance;
        chat.create = baseModel.created;
        chat.status = baseModel.status;
        chat.name = baseModel.name;
        chat.userphone = baseModel.userphone;
        chat.userid = baseModel.userid;
        chat.conversationType = ConversationType_GROUP;// 设置模型会话类型
        chat.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;// 设置模型类型
        for (RCConversationModel *conversation in dataSource) {
            // 从接口获取到的订单数据全部都要显示 订单数据没有的融云有的不显示
            if ([chat.order_sn isEqualToString:conversation.targetId]) {
                chat.conversationModel = conversation;
            }
        }
        [self.chatListArray addObject:chat];
    }
    
    
    
    self.conversationListDataSource = self.chatListArray;
    
    
    
    
    return self.chatListArray;
}

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    RCMessage *message = (RCMessage *)notification.object;
    
    
    NSLog(@"%@",notification);
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    MainTabBarController *tabVC = (MainTabBarController *)delegate.window.rootViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *userid = [message.senderUserId substringFromIndex:1];
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"orderinfo",@"api",@"1",@"version",userid,@"userid",message.targetId,@"order_sn",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"equment",nil];
        NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dataDic];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //        NSLog(@"%@",responseObject);
            NSNumber *result = responseObject[@"status"];
            if (!result.integerValue) {
                NSDictionary *data = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                NSLog(@"%@",data);
                BaseModel *model = [[BaseModel alloc] init];
                [model setValuesForKeysWithDictionary:data[@"orderlist"][0]];
                self.baseModel = model;
                NSLog(@"%@",_baseModel);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (tabVC.selectedIndex == 1) {
                        if ([tabVC.chatListVC.navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]) {//  如果当前栈顶元素为聊天页面
                            ChatViewController *chatVC = (ChatViewController *)tabVC.chatListVC.navigationController.viewControllers.lastObject;
                            if (![chatVC.model.order_sn isEqualToString:_baseModel.order_sn]) {// 如果当前聊天页面的和接收到消息的订单号不一致 弹窗提示
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alert.tag = 1234;
                                [alert show];
                                
                            }
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 1234;
                            [alert show];
                        }
                    } else if (tabVC.selectedIndex == 0) {
                        if ([tabVC.homeVc.navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]) {//  如果当前栈顶元素为聊天页面
                            ChatViewController *chatVC = (ChatViewController *)tabVC.homeVc.navigationController.viewControllers.lastObject;
                            if (![chatVC.model.order_sn isEqualToString:_baseModel.order_sn]) {// 如果当前聊天页面的和接收到消息的订单号不一致 弹窗提示
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alert.tag = 1234;
                                [alert show];
                                
                            }
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 1234;
                            [alert show];
                        }
                    } else if (tabVC.selectedIndex == 2) {
                        if ([tabVC.personVC.navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]) {//  如果当前栈顶元素为聊天页面
                            ChatViewController *chatVC = (ChatViewController *)tabVC.personVC.navigationController.viewControllers.lastObject;
                            if (![chatVC.model.order_sn isEqualToString:_baseModel.order_sn]) {// 如果当前聊天页面的和接收到消息的订单号不一致 弹窗提示
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alert.tag = 1234;
                                [alert show];
                                
                            }
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有一条新消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 1234;
                            [alert show];
                        }
                    }
                    
                    [self.conversationListTableView reloadData];
                    
                });
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    });
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    MainTabBarController *tabVC = (MainTabBarController *)delegate.window.rootViewController;
    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:_baseModel];
    //设置会话的类型，如单聊、讨论[组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _baseModel.order_sn;
    
    //设置聊天会话界面要显示的标题
    chatVC.title = self.baseModel.userphone;
    
        
    //显示聊天会话界面
    //        [self.navigationController pushViewController:chatVC animated:YES];
    
    
    if (tabVC.selectedIndex == 0) {
        [tabVC.homeVc.navigationController pushViewController:chatVC animated:YES];
    } else if (tabVC.selectedIndex == 1) {
        [tabVC.chatListVC.navigationController pushViewController:chatVC animated:YES];
    } else {
        [tabVC.personVC.navigationController pushViewController:chatVC animated:YES];
    }
    
}

// 高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

// 自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
//        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatListCell" owner:nil options:nil] lastObject];
        
        float sortaPixel = 1.0/ [UIScreen mainScreen].scale;
        cell.line = [[UIView alloc] init];
        cell.line.frame = CGRectMake(0,125,cell.width, sortaPixel);
        cell.line.backgroundColor = [UIColor colorWithRed:193  / 255.0 green:26 / 255.0 blue:32 / 255.0 alpha:1.0];
        [cell.contentView addSubview:cell.line];
    }
//    [cell setDataModel:self.conversationListDataSource[indexPath.row]];
//    if (self.chatListArray.count == self.conversationListDataSource.count) {
//        ChatListModel *chatModel = nil;
//        for (ChatListModel *chat in self.chatListArray) {
//            if ([chat.order_sn isEqualToString:[self.conversationListDataSource[indexPath.row] targetId]] ) {
//                chatModel = chat;
//            }
////        }
//        [cell setDataChatModel:chatModel];
    [cell setDataChatModel:self.conversationListDataSource[indexPath.row]];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor orangeColor];
//    RCConversationModel *a = self.conversationListDataSource[0];
    return cell;
}

//
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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

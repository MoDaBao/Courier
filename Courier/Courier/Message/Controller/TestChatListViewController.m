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

@interface TestChatListViewController ()

/**
 *  后台请求数据数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  消息列表数据源
 */
@property (nonatomic, strong) NSMutableArray *chatListArray;


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



- (instancetype)init {
    if (self = [super init]) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
        //        [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
        [self requestData];
        
    }
    return self;
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
}

// 请求会话列表的订单数据
- (void)requestDataWithDataArray:(NSMutableArray*)dataArray {
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_userid_",[[CourierInfoManager shareInstance] getCourierPid],@"type",@"2",@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",@"1.2.1",@"BaseAppVersion",[MyMD5 md5:str],@"_sign_",[MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]],@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_",@"2",@"type",[[CourierInfoManager shareInstance] getCourierPid],@"userid",nil];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain",@"text/javascript",@"application/json",@"text/json",nil]];
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
            [self.chatListArray removeAllObjects];
            for (RCConversationModel *model in dataArray) {
                for (BaseModel *baseModel in self.dataArray) {
                    if ([model.targetId isEqualToString:baseModel.order_sn]) {
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
                        chat.conversationModel = model;
                        
                        [self.chatListArray addObject:chat];
                    }
                }
            }
            NSMutableArray *tempArray = [NSMutableArray array];
            for (RCConversationModel *model in dataArray) {
                NSInteger temp = 0;
                for (BaseModel *chat in self.chatListArray) {
                    if ([model.targetId isEqualToString:chat.order_sn]) {
                        temp ++;
                    }
                    
                }
                if (temp == 0) {
                    [tempArray addObject:model];
                }
            }
            
            [dataArray removeObjectsInArray:tempArray];
            
//            for (NSInteger i = 0; i < self.chatListArray.count; i ++) {
//                for (NSInteger j = 0; j < dataArray.count; j ++) {
//                    ChatListModel *chat = self.chatListArray[i];
//                    RCConversationModel *model = dataArray[j];
//                    if ([chat.order_sn isEqualToString:model.targetId]) {
//                        [dataArray removeObject:model];
//                        [dataArray insertObject:model atIndex:i];
//                    }
//                }
//            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationListTableView reloadData];
            });
            
        }
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
        chatVC.title = baseModel.userphone;
        
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
    [self requestData];
    
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
    
    
    
    
    
    return self.chatListArray;
}

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSLog(@"%@",notification);
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

//
//  ChatListViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/28.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "TestChatListViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
//        [self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loadi8ng the view.
    self.navigationItem.title = @"消息列表";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 30);
    [button setTitle:@"test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)test {
    TestChatListViewController *testVC = [[TestChatListViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}


// push到会话页面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        ChatListViewController *temp = [[ChatListViewController alloc] init];
        [temp setDisplayConversationTypes:@[@(model.conversationType)]];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    } else if (model.conversationType == ConversationType_GROUP) {
//        ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:nil];
        ChatViewController *chatVC = [[ChatViewController alloc] init];
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.targetId;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    
}

//- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
////    self.conversationListDataSource = [super willReloadTableData:dataSource];
//    self.conversationListDataSource = [NSMutableArray array];
//    for (RCConversationModel *model in dataSource) {
//        model.isTop = NO;
//        [self.conversationListDataSource addObject:model];
//    }
//    return self.conversationListDataSource;
//}

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

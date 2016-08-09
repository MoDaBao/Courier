//
//  WriteInfoViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "WriteInfoViewController.h"
#import "SearchMapViewController.h"
#import "WriteInfoBuyView.h"
#import "MessageBarButton.h"
#import "ChatViewController.h"

@interface WriteInfoViewController ()<SearchMapViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WriteInfoView_2 *writeView;
@property (nonatomic, strong) WriteInfoBuyView *writeBuyView;

@property (nonatomic, copy) NSString *start_latitude;
@property (nonatomic, copy) NSString *start_longitude;
@property (nonatomic, copy) NSString *end_latitude;
@property (nonatomic, copy) NSString *end_longitude;



@end

@implementation WriteInfoViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_start_latitude  && _start_longitude &&  _end_longitude && _end_latitude) {
        NSDictionary *dic = @{@"api":@"pDistance", @"version":@"1", @"start_latitude":_start_latitude, @"start_longitude":_start_longitude, @"end_latitude":_end_latitude, @"end_longitude":_end_longitude};
        NSString *paramater = [EncryptionAndDecryption encryptionWithDic:dic];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":paramater} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = responseObject[@"status"];
            if (!result.integerValue) {
                NSLog(@"成功");
                NSDictionary *dic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
                self.writeView.totalDistance.text = [NSString stringWithFormat:@"%@m",dic[@"distance"]];
                self.writeView.totalCost.text = [NSString stringWithFormat:@"%@￥",dic[@"price"]];
                self.writeBuyView.totalDistance.text = [NSString stringWithFormat:@"%@m",dic[@"distance"]];
                self.writeBuyView.totalCost.text = [NSString stringWithFormat:@"%@￥",dic[@"price"]];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填写信息";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    MessageBarButton *message = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"消息" font:[UIFont systemFontOfSize:13]];
//    WriteInfoViewController *writeVC = self;
    message.click = ^ {
        // 这里要根据订单生成一个会话
        [self chat];// 调出聊天窗口
        NSLog(@"点击了消息item");
    };
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    scrollView.contentOffset = CGPointMake(0, 0);
//    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];

    if (self.baseModel.type.integerValue == 3) {// 买的时候加载购买的填单view
        self.writeBuyView = [[[NSBundle mainBundle] loadNibNamed:@"WriteInfoBuyView" owner:nil options:nil] lastObject];
        //    self.writeBuyView setda÷÷
        self.writeBuyView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        self.writeBuyView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight);
        scrollView.backgroundColor = self.writeBuyView.backgroundColor;
        [scrollView addSubview:self.writeBuyView];
        self.writeBuyView.receivingTF.text = _baseModel.userphone;
        if (_baseModel.start.length) {
            self.writeBuyView.startTF.text = _baseModel.start;
            self.writeBuyView.endTF.text = _baseModel.end;
            _start_latitude = _baseModel.start_latitude;
            _start_longitude = _baseModel.start_longitude;
            _end_latitude = _baseModel.end_latitude;
            _end_longitude = _baseModel.end_longitude;
        }
        [self.writeBuyView.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.writeBuyView.startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];// 点击进入地图选择起始地点
        [self.writeBuyView.endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];// 点击进入地图选择收货地点
    } else {// 送 拿
        self.writeView = [[[NSBundle mainBundle] loadNibNamed:@"WriteInfoView_2" owner:nil options:nil] lastObject];
        [self.writeView setDataWithModel:self.baseModel];
        self.writeView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        self.writeView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight);
        scrollView.backgroundColor = self.writeView.backgroundColor;
        [scrollView addSubview:self.writeView];
        self.writeView.receivingTF.text = _baseModel.userphone;
        if (_baseModel.start.length) {
            self.writeView.startTF.text = _baseModel.start;
            self.writeView.endTF.text = _baseModel.end;
            _start_latitude = _baseModel.start_latitude;
            _start_longitude = _baseModel.start_longitude;
            _end_latitude = _baseModel.end_latitude;
            _end_longitude = _baseModel.end_longitude;
        }
        [self.writeView.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.writeView.startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];// 点击进入地图选择起始地点
        [self.writeView.endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];// 点击进入地图选择收货地点
    }
  
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    
    
}

// 如果是地址已经填好的帮我买订单要调用这个方法赋值
- (void)buy {
    
}


// 调出聊天界面
- (void)chat {
    
    //新建一个聊天会话View Controller对象ler alloc]init];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:self.baseModel];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _baseModel.order_sn;
    
    //设置聊天会话界面要显示的标题
    chatVC.title = self.baseModel.userphone;
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)returnKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}


- (void)sendBtnClick {
    
    // 判断有无输入地址
//    if (self.writeView) {
//        <#statements#>
//    }
    
    // 判断有无输入手机号
    if ([self.writeView.receivingTF.text isEqualToString:@""] || [self.writeView.pusherPhoneTF.text isEqualToString:@""] || [self.writeBuyView.receivingTF.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    // 网络请求参数
//    NSString *is_bonus = _baseModel.bonus_id ? @"1" : @"0";// 是否有红包 0是无  1是有
    NSString *parameter = nil;
    NSString *note = _baseModel.note ? _baseModel.note : @"";
    if (self.writeView.isChoose) {// 判断有无选择默认起送价
        _start_latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        _start_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        _end_latitude = _start_latitude;
        _end_longitude = _start_longitude;
        
        
    }
    if (self.writeBuyView.isChoose) {
        _start_latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        _start_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        _end_latitude = _start_latitude;
        _end_longitude = _start_longitude;
    }
    if (self.baseModel.type.intValue == 3) {
        // 买
        
        if (self.writeBuyView.buyPrice.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入物品价格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"pcreateOrder_pay", @"api",
        @"1", @"version",
        [NSString stringWithFormat:@"%d",_baseModel.type.intValue], @"type",
        [NSString stringWithFormat:@"%@",self.baseModel.userid], @"userid",
        self.writeBuyView.startTF.text, @"start",
        _start_longitude, @"start_longitude",
        _start_latitude, @"start_latitude",
        self.writeBuyView.receivingTF.text, @"phone",
        self.writeBuyView.endTF.text, @"end",
        _end_longitude, @"end_longitude",
        _end_latitude, @"end_latitude",
        _baseModel.psend_time, @"psend_time",
        _baseModel.order_sn, @"order_sn",
        note, @"note",
        self.writeBuyView.buyPrice.text, @"buyprice",
        [[CourierInfoManager shareInstance] getCourierPid], @"pid",
        nil];
        parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    } else {
        // 送 拿
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"pcreateOrder", @"api",
        @"1", @"version",
        [NSString stringWithFormat:@"%d",_baseModel.type.intValue], @"type",
        [NSString stringWithFormat:@"%@",self.baseModel.userid], @"userid",
        self.writeView.startTF.text, @"start",
        _start_longitude, @"start_longitude",
        _start_latitude, @"start_latitude",
        self.writeView.receivingTF.text, @"phone",
        self.writeView.endTF.text, @"end",
        _end_longitude, @"end_longitude",
        _end_latitude, @"end_latitude",
        _baseModel.psend_time, @"psend_time",
        _baseModel.order_sn, @"order_sn",
        note, @"note",
        self.writeView.pusherPhoneTF.text, @"start_phone",
        [[CourierInfoManager shareInstance] getCourierPid], @"pid",
        nil];
        parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    }
    
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.integerValue) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                /*
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertC dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertC addAction:confirm];
                [self.navigationController presentViewController:alertC animated:YES completion:nil];
                 */
            } else {
                self.refresh();
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];

    
}

- (void)startBtnClick {
    SearchMapViewController *searchVC = [[SearchMapViewController alloc] init];
    searchVC.delegate = self;
    searchVC.baseModel = self.baseModel;
    if (self.baseModel.type.intValue == 3) {
        searchVC.clickedTF = self.writeBuyView.startTF;
    } else {
        searchVC.clickedTF = self.writeView.startTF;
    }
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)endBtnClick {
    SearchMapViewController *searchVC = [[SearchMapViewController alloc] init];
    searchVC.delegate = self;
    searchVC.baseModel = self.baseModel;
    if (self.baseModel.type.intValue == 3) {
        searchVC.clickedTF = self.writeBuyView.endTF;
    } else {
        searchVC.clickedTF = self.writeView.endTF;
    }
    [self.navigationController pushViewController:searchVC animated:YES];
}

// 地图页面传值赋值代理方法
- (void)pushAddress:(NSString *)address latitude:(NSString *)latitude longitude:(NSString *)longitude clickedTextFiled:(UITextField *)tf {
    if (tf == self.writeView.startTF || tf == self.writeBuyView.startTF) {
        self.start_latitude = latitude;
        self.start_longitude = longitude;
    } else {
        self.end_latitude = latitude;
        self.end_longitude = longitude;
    }
    tf.text = address;
}

- (void)cancelOrder {
    NSLog(@"取消订单");
}

- (void)back {
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

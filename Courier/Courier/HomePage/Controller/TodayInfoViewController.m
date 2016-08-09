//
//  TodayInfoViewController.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TodayInfoViewController.h"
#import "TodayInfoItemView.h"
#import "CourierInfoModel.h"
#import "TodayInfoView.h"

@interface TodayInfoViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CourierInfoModel *courierInfoModel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TodayInfoViewController

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
}

- (void)requestCourierInfo {
    // 创建参数字符串
    NSString *parameterStr = [EncryptionAndDecryption encryptionWithDic:@{@"api":@"myinfo", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid]}];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameterStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        // 将获取到的data字符串数据转化成字典
        NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
        NSLog(@"dataDic = %@", dataDic);
        self.courierInfoModel = nil;
        self.courierInfoModel = [[CourierInfoModel alloc] init];
        [self.courierInfoModel setValuesForKeysWithDictionary:dataDic];
        [self.dataArray addObject:@{@"今日有效单":[NSString stringWithFormat:@"%ld单",self.courierInfoModel.count.integerValue]}];
        [self.dataArray addObject:@{@"今日里程":[NSString stringWithFormat:@"%.2f千米",self.courierInfoModel.distance.floatValue / 1000.0]}];
        [self.dataArray addObject:@{@"在线支付跑腿费":[NSString stringWithFormat:@"%ld元",self.courierInfoModel.db_online.integerValue]}];
        [self.dataArray addObject:@{@"货到付款跑腿费":[NSString stringWithFormat:@"%ld元",self.courierInfoModel.db_unonline.integerValue]}];
        [self.dataArray addObject:@{@"在线支付物品费":[NSString stringWithFormat:@"%ld元",self.courierInfoModel.buy_online.integerValue]}];
        [self.dataArray addObject:@{@"货到付款物品费":[NSString stringWithFormat:@"%ld元",self.courierInfoModel.buy_unonline.integerValue]}];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 获取数据之后创建视图
            [self createView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)createView {
    TodayInfoView *infoView = [[TodayInfoView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 20, kScreenWidth, 280 * kScaleForWidth) dataArray:self.dataArray];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"今日统计";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self requestCourierInfo];
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

//
//  MapNavViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/9/13.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MapNavViewController.h"

@interface MapNavViewController ()


@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;



@end

@implementation MapNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"导航";
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
//    //设置导航的起点和终点
//    self.startPoint = [AMapNaviPoint locationWithLatitude:39.989773 longitude:116.479872];
//    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.995839 longitude:116.451204];
    
    //初始化AMapNaviDriveView
    if (self.driveView == nil) {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        
        [self.view addSubview:self.driveView];
    }
    
    //初始化AMapNaviDriveManager
    if (self.driveManager == nil) {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
    
    //将AMapNaviManager与AMapNaviDriveView关联起来
    [self.driveManager addDataRepresentative:self.driveView];
    //将AManNaviDriveView显示出来
    [self.view addSubview:self.driveView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    //路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategyDefault];
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
}


- (void)back {
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

//
//  TestMapViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/7/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TestMapViewController.h"

@interface TestMapViewController ()<AMapNaviDriveViewDelegate>

//@property (nonatomic, strong) AMapNaviDriveView *naviDriveView;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation TestMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view.
    
//    self.naviDriveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
//    self.naviDriveView.delegate = self;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    [self.view addSubview:_mapView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"back" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    
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

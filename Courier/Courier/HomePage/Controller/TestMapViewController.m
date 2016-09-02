//
//  TestMapViewController.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/8/8.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "TestMapViewController.h"


@interface TestMapViewController ()<RCLocationPickerViewControllerDataSource>
{
    UIButton *_right;
    CLLocationCoordinate2D coor; //经纬度
    
}

@end

@implementation TestMapViewController
@synthesize search;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发送位置";
//    self.navigationController.navigationBar.translucent = NO;
    
    _right = [UIButton buttonWithType:UIButtonTypeCustom];
    _right.frame = CGRectMake(0, 0, 40, 40);
    [_right setTitle:@"发送" forState:UIControlStateNormal];
//    Color(193, 26, 32, 1)
    [_right setTitleColor:[UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] forState:UIControlStateNormal];
    [_right addTarget:self action:@selector(testSendr) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightIten = [[UIBarButtonItem alloc] initWithCustomView:_right];
    self.navigationItem.rightBarButtonItem = rightIten;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)testSendr
{
    [super rightBarButtonItemPressed:_right];
//    if (self.delegate) {
//        [self.delegate locationPicker:self
//                    didSelectLocation:[self currentLocationCoordinate2D]
//                         locationName:[self currentLocationName]
//                        mapScreenShot:[self currentMapScreenShot]];
//    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

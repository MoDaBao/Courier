//
//  SettingDetailVC.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/6/20.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "SettingDetailVC.h"

@interface SettingDetailVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end

@implementation SettingDetailVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = self.titleStr;
    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.webview.scalesPageToFit = YES;
    self.webview.clipsToBounds = YES;
    self.webview.delegate = self;
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

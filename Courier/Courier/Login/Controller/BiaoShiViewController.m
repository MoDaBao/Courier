//
//  BiaoShiViewController.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/18.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "BiaoShiViewController.h"
#import "ApplyViewController.h"
#import "MyMD5.h"

@interface BiaoShiViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cont;

@end

@implementation BiaoShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"申请镖师";
    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
//    self.navigationController.navigationBar.translucent = NO;
    
    self.saveBtn.layer.cornerRadius = 20;
    self.saveBtn.clipsToBounds = YES;
    
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    if (self.view.frame.size.height < 570)
    {
        self.cont.constant = 100;
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(UIButton *)sender
{
    ApplyViewController *VC = [[ApplyViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end

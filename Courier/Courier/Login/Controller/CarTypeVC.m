//
//  CarTypeVC.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/19.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "CarTypeVC.h"
#import "ApplyViewController.h"

@interface CarTypeVC ()<UIGestureRecognizerDelegate>
{
    NSString *_carStr;
}
@property (weak, nonatomic) IBOutlet UIView *view_1;
@property (weak, nonatomic) IBOutlet UIView *view_2;
@property (weak, nonatomic) IBOutlet UIView *view_3;
@property (weak, nonatomic) IBOutlet UIView *view_4;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation CarTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"选择车型";
    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
//    self.navigationController.navigationBar.translucent = NO;
    
    self.commitBtn.layer.cornerRadius = 20;
    self.commitBtn.clipsToBounds = YES;
    
    self.view_1.layer.cornerRadius = 8;
    self.view_1.clipsToBounds = YES;
    self.view_1.layer.borderWidth = 1;
    self.view_1.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    
    self.view_2.layer.cornerRadius = 8;
    self.view_2.clipsToBounds = YES;
    self.view_2.layer.borderWidth = 1;
    self.view_2.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    
    self.view_3.layer.cornerRadius = 8;
    self.view_3.clipsToBounds = YES;
    self.view_3.layer.borderWidth = 1;
    self.view_3.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    
    self.view_4.layer.cornerRadius = 8;
    self.view_4.clipsToBounds = YES;
    self.view_4.layer.borderWidth = 1;
    self.view_4.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
//    _carStr = @"电动车";
     self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.scroll.contentSize = CGSizeMake(0,0);
    if (self.view.frame.size.height < 570)
    {
        self.scroll.contentSize = CGSizeMake(0, self.view.frame.size.height + 150);
    }
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
    
}

- (IBAction)chooseBtnClick:(UIButton *)sender
{
    self.view_1.backgroundColor = [UIColor whiteColor];
    self.view_2.backgroundColor = [UIColor whiteColor];
    self.view_3.backgroundColor = [UIColor whiteColor];
    self.view_4.backgroundColor = [UIColor whiteColor];
    self.view_1.layer.borderWidth = 1;
    self.view_2.layer.borderWidth = 1;
    self.view_3.layer.borderWidth = 1;
    self.view_4.layer.borderWidth = 1;
    
    switch (sender.tag)
    {
        case 1:
            self.view_1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            self.view_1.layer.borderWidth = 5;
            _carStr = @"1";
            break;
            
        case 2:
            self.view_2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            self.view_2.layer.borderWidth = 5;
            _carStr = @"2";
            break;
            
        case 3:
            self.view_3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            self.view_3.layer.borderWidth = 5;
            _carStr = @"3";
            break;
            
        case 4:
            self.view_4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
            self.view_4.layer.borderWidth = 5;
            _carStr = @"4";
            break;
            
        default:
            break;
    }
}
- (IBAction)commitBtnClick:(UIButton *)sender
{
    if ([_carStr integerValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择车型！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    ApplyViewController *VC = [self.navigationController.childViewControllers objectAtIndex:[self.navigationController.childViewControllers count] - 2];
    VC.carTypeStr = _carStr;
    [self.navigationController popToViewController:VC animated:YES];
}

@end

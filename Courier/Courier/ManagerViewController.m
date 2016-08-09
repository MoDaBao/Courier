	//
//  ManagerViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/6/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

//


#import "ManagerViewController.h"
#import "LoginViewController.h"

@interface ManagerViewController ()

@end

@implementation ManagerViewController


- (void)setRootVC:(UIViewController *)rootVC {
    __block UIViewController *tempVC = _rootVC;// 原先的根视图控制器
    _rootVC = rootVC;// 赋值新的根视图控制器
    if (_rootVC) {
        if (tempVC) {
            if ([tempVC isKindOfClass:[LoginViewController class]]) {// 原先的根视图控制器为loginVC 需要动画效果
                UIView *view = _rootVC.view;// 新根视图控制器的根视图
                view.frame = self.view.bounds;
                [self.view addSubview:view];// 将新根视图控制器的根视图添加到self.view上
                for (UIView *tempView in self.view.subviews) {
                    if (tempView == tempVC.view) {
                        [self.view bringSubviewToFront:tempView];
                        [UIView animateWithDuration:.3 animations:^{
                            tempView.y = kScreenHeight;
                            NSLog(@"%@",tempView);
                        } completion:^(BOOL finished) {
                            [tempVC.view removeFromSuperview];
                            tempVC = nil;
                        }];
                    }
                }
                
            }
            
        } else {// tempVC为空 程序第一次启动  不需要动画效果
            UIView *view = _rootVC.view;// 新根视图控制器的根视图
            view.frame = self.view.bounds;
            [self.view addSubview:view];
        }
        
    }
    // 程序刚启动时应用显示登录页面时不需要动画效果  tempVC为空时代表程序刚启动

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setRootVC:self.rootVC];
    
    
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

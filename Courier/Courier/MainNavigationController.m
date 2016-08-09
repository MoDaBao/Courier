//
//  MainNavigationController.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 余钦 on 16/5/30.
//  Copyright © 2016年 yuqin. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MainNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight - 20, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.83 green:0.13 blue:0.10 alpha:1.00];
    [self.navigationBar addSubview:line];
    
}

 //这里可以封装成一个分类
- (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 40, 40);
    button.imageView.contentMode = UIViewContentModeLeft;
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    
        UIBarButtonItem *popToPreButton = [self barButtonItemWithImage:@"SVWebViewControllerBack" highImage:nil target:self action:@selector(popToPre)];
        viewController.navigationItem.leftBarButtonItem = popToPreButton;
    }
    [super pushViewController:viewController animated:animated];

}

- (void)popToPre {
    [self popViewControllerAnimated:YES];
}


#pragma mark --------navigation delegate
//该方法可以解决popRootViewController时tabbar的bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }

}
@end

//
//  LoginViewController.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginsetAddress:(NSString *)address;
- (void)showAlert;// 弹出账号在另一台设备上登录的弹窗
- (void)initRong;// 初始化融云

@end


@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL isDismiss;// NO代表不是dismiss
@property (nonatomic, assign) id<LoginViewControllerDelegate>delegate;

@end

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

@end


@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL isDismiss;// NO代表不是dismiss
@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

@end

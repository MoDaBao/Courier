//
//  MainTabBar.h
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;

@protocol MainTabBarDelegate <NSObject>

@optional

- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;
- (void)tabBarClickWriteButton:(MainTabBar *)tabBar;

@end

@interface MainTabBar : UIView

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;
@property(nonatomic, weak)id <MainTabBarDelegate>delegate;

@end

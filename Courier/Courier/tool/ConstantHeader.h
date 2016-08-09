//
//  ConstantHeader.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#ifndef ConstantHeader_h
#define ConstantHeader_h



#define kScreenWidth [UIScreen mainScreen].bounds.size.width// 屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height// 屏幕高度
#define kStatusHeight 20// 状态条高度
#define kScaleForText ([UIScreen mainScreen].bounds.size.width / 375.0)// 文字比例
#define kNavigationBarHeight 64// 导航栏高度+状态条的高度
#define KTabBarHeight 44// 标签栏高度

#define kScaleForWidth ([UIScreen mainScreen].bounds.size.width / 375.0)// 当前屏幕宽度与iPhone6屏幕宽度的比例

#define kScaleForHeight ([UIScreen mainScreen].bounds.size.height / 667.0)// 当前屏幕高度与iPhone6屏幕高度的比例


#define kHeartWidth 24// 爱心图片的宽度
#define kHeartHeight 18// 爱心图片的高度

#define REQUESTURL @"http://api.tzouyi.com/"
//#define REQUESTURL @"http://121.41.37.126/" //测试链接

#endif /* ConstantHeader_h */

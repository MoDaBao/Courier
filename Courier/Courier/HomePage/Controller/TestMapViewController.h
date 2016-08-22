//
//  TestMapViewController.h
//  RunErrands
//
//  Created by 朱玉涵 on 16/8/8.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface TestMapViewController : RCLocationPickerViewController
@property (nonatomic, strong) AMapSearchAPI *search;
@end

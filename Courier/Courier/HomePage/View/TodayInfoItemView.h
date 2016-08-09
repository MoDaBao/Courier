//
//  TodayInfoItemVIew.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayInfoItemView : UIView


@property (nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value;


@end

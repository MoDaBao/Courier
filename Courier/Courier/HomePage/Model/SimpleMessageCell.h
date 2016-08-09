//
//  SimpleMessageCell.h
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 * 文本消息Cell
 */
@interface SimpleMessageCell : RCMessageCell

/**
 * 消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end

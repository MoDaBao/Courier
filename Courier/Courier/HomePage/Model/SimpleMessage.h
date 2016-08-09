//
//  SimpleMessage.h
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCLocalMessageTypeIdentifier @”RC:SimpleMsg”

/**
 * 文本消息类定义
 */
@interface SimpleMessage : RCMessageContent <NSCoding,RCMessageContentView>
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end



//
//  NSString+EncodeAndDecode.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EncodeAndDecode)

// 编码
+ (NSString *)base64EncodeWithString:(NSString *)string;

// 解码
+ (NSString *)base64DecodeWithString:(NSString *)string;

// 字符替换
+ (NSString *)NewStrReplaceOldStrWithString:(NSString *)string newStr:(NSString *)newStr oldStr:(NSString *)oldStr;

@end

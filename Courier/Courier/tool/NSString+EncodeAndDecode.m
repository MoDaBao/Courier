//
//  NSString+EncodeAndDecode.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NSString+EncodeAndDecode.h"

@implementation NSString (EncodeAndDecode)


// 编码
+ (NSString *)base64EncodeWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

// 解码
+ (NSString *)base64DecodeWithString:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

// 字符替换
+ (NSString *)NewStrReplaceOldStrWithString:(NSString *)string newStr:(NSString *)newStr oldStr:(NSString *)oldStr {
    NSString *temp = nil;
    NSInteger oldLength = oldStr.length;
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"%@",string];
    for(NSInteger i = 0; i < [mStr length] - (oldLength - 1); i++)
    {
        temp = [mStr substringWithRange:NSMakeRange(i, oldLength)];
//        NSLog(@"第%d个字是:%@",i,temp);
        if ([temp isEqualToString:oldStr]) {
            [mStr replaceCharactersInRange:NSMakeRange(i, oldLength) withString:newStr];
        }
    }
    return [NSString stringWithFormat:@"%@",mStr];
}


@end

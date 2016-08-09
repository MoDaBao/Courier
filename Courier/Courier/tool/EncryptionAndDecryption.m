//
//  EncryptionAndDecryption.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "EncryptionAndDecryption.h"

@implementation EncryptionAndDecryption

//  把字典加密成请求参数
+ (NSString *)encryptionWithDic:(NSDictionary *)dic {
    // 将字典转换成JSON字符串
    NSString *jsonStr = [NSDictionary DicChangeJson:dic];
    // 将json字符串做base64编码处理 编码
    NSString *encodeStr = [NSString base64EncodeWithString:jsonStr];
    // 根据加密规则替换指定字符 加密
    NSString *parameterStr = [NSString NewStrReplaceOldStrWithString:encodeStr newStr:@"^dfk" oldStr:@"c"];
//    NSLog(@"replaceStr = %@",parameterStr);
    return parameterStr;
}

//  把获得的经过加密的数据进行解密
+ (NSDictionary *)decryptionWithString:(NSString *)string {
    // 替换字符 解密字符串
    NSString *replaced = [NSString NewStrReplaceOldStrWithString:string newStr:@"c" oldStr:@"^dfk"];
    
    // 解码
    NSString *decodeStr = [NSString base64DecodeWithString:replaced];
    NSLog(@"decode = %@",decodeStr);
    
    // json字符串转化为字典
    NSDictionary *dataDic = [NSDictionary JsonChangeDic:decodeStr];
//    NSLog(@"dataDic = %@",dataDic);
    
    return dataDic;
}

@end

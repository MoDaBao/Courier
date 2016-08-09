//
//  EncryptionAndDecryption.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionAndDecryption : NSObject

//  把字典加密成请求参数
+ (NSString *)encryptionWithDic:(NSDictionary *)dic;

//  把获得的经过加密的数据进行解密
+ (NSDictionary *)decryptionWithString:(NSString *)string;

@end

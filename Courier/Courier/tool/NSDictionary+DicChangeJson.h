//
//  NSDictionary+DicChangeJson.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DicChangeJson)

// 字典转化成json字符串
+ (NSString *)DicChangeJson:(NSDictionary *)dic;

// json字符串转化成字典
+ (NSDictionary *)JsonChangeDic:(NSString *)json;

@end

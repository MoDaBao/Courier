//
//  NSDictionary+DicChangeJson.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NSDictionary+DicChangeJson.h"

@implementation NSDictionary (DicChangeJson)

// 字典转化成json字符串
+ (NSString *)DicChangeJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// json字符串转化成字典
+ (NSDictionary *)JsonChangeDic:(NSString *)json {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
}

@end

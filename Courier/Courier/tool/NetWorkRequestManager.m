//
//  NetWorkRequestManager.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager



+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requsetError:(RequestError)requsetError {
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic requestFinish:requestFinish requsetError:requsetError];
}


- (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requsetError:(RequestError)requsetError {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (type == POST) {
        request.HTTPMethod = @"POST";
        if (parDic.count > 0) {
            request.HTTPBody = [self getDataByDic:parDic];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            requestFinish(data);
        } else {
            requsetError(error);
        }
    }];
    [task resume];
}

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString json:(NSString *)json requestFinish:(RequestFinish)requestFinish requsetError:(RequestError)requsetError {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    if (type == POST) {
//        request.HTTPMethod = @"POST";
//        if (parDic.count > 0) {
//            request.HTTPBody = [self getDataByDic:parDic];
//        }
//    }
    
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            requestFinish(data);
        } else {
            requsetError(error);
        }
    }];
    [task resume];
}


- (NSData *)getDataByDic:(NSDictionary *)dic {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key, dic[key]];
        [mArr addObject:str];
    }
    //将数组里的所有元素都用&连接
    NSString *string = [mArr componentsJoinedByString:@"&"];
//    NSLog(@"%@",string);
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


@end

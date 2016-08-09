//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    POST,
    GET
}RequestType;

typedef void (^RequestFinish)(NSData *data);
typedef void (^RequestError)(NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestFinish:(RequestFinish)requestFinish requsetError:(RequestError)requsetError;


+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString json:(NSString *)json requestFinish:(RequestFinish)requestFinish requsetError:(RequestError)requsetError;



@end

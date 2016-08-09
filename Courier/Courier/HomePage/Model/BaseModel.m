//
//  BaseModel.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

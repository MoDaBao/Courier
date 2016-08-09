//
//  WaitOrdrReceivingModel.m
//  Courier
//
//  Created by 莫大宝 on 16/6/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "WaitOrdrReceivingModel.h"

@implementation WaitOrdrReceivingModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end

//
//  DeliveryModel.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DeliveryModel.h"

@implementation DeliveryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end

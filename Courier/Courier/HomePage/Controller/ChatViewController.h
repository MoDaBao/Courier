//
//  ChatViewController.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/28.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "BaseModel.h"

@interface ChatViewController : RCConversationViewController

@property (nonatomic, strong) BaseModel *model;
- (instancetype)initWithModel:(BaseModel *)model;

@end

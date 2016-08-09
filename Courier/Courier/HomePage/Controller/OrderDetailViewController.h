//
//  OrderDetailViewController.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyDoneModel.h"
#import "BaseModel.h"


@interface OrderDetailViewController : UIViewController

@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, assign) BOOL isAlreadyDone;//  是否是已完成的订单//yes隐藏消息按钮  No显示消息按钮

@property (nonatomic, copy) NSString *orderStatus;//  订单状态

@end

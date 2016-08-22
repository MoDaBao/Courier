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

@protocol OrderDetailViewControllerDelegate <NSObject>

- (void)refreshDelivery;

@end

@interface OrderDetailViewController : UIViewController

@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, assign) BOOL isAlreadyDone;//  是否是已完成的订单//yes隐藏消息按钮  No显示消息按钮

@property (nonatomic, assign) BOOL isDelivery;// 是否是配送中的订单 配送中的单子要显示按钮

@property (nonatomic, copy) NSString *orderStatus;//  订单状态

@property (nonatomic, assign) id<OrderDetailViewControllerDelegate> delegate;

@end

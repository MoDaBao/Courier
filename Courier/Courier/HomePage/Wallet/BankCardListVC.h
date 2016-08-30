//
//  BankCardListVC.h
//  Courier
//
//  Created by 朱玉涵 on 16/8/26.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankNameDelegate <NSObject>
- (void)setBankNameActionWithDict:(NSDictionary *)bankDic;
@end

@interface BankCardListVC : UIViewController
@property (nonatomic, assign) id<BankNameDelegate>bankNameDelegate;
@end

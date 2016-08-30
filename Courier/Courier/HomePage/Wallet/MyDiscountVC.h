//
//  MyDiscountVC.h
//  Courier
//
//  Created by 朱玉涵 on 16/8/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDiscountVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;// 提示
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;// 我的货款
@property (weak, nonatomic) IBOutlet UILabel *order_total;// 有效单数
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;// 在线支付跑腿费
@property (weak, nonatomic) IBOutlet UILabel *delivery_amount;// 货到付款跑腿费
@property (weak, nonatomic) IBOutlet UILabel *online_pay_balance;// 在线支付物品费
@property (weak, nonatomic) IBOutlet UILabel *delivery_item_amount;// 货到付款物品费








@end

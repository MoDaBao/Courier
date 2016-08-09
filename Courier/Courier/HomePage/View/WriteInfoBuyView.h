//
//  WriteInfoBuyView.h
//  Courier
//
//  Created by 莫大宝 on 16/7/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteInfoBuyView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UITextField *startTF;// 送货地址
@property (weak, nonatomic) IBOutlet UITextField *endTF;// 收货地址
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;// 点击使用默认起送价
@property (weak, nonatomic) IBOutlet UIButton *defaultStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultStatusButton;


@property (weak, nonatomic) IBOutlet UITextField *receivingTF;// 收货电话
@property (weak, nonatomic) IBOutlet UILabel *totalDistance;// 总距离
@property (weak, nonatomic) IBOutlet UILabel *totalCost;// 总费用
@property (weak, nonatomic) IBOutlet UITextField *buyPrice;// 物品价格

@property (weak, nonatomic) IBOutlet UIButton *startBtn;// 选择送货地址按钮
@property (weak, nonatomic) IBOutlet UIButton *endBtn;// 选择收货地址按钮
//@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, assign) BOOL isChoose;



@end

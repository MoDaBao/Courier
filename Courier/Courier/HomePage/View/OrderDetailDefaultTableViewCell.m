//
//  OrderDetailDefaultTableViewCell.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/17.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "OrderDetailDefaultTableViewCell.h"
#import "AppDelegate.h"

@interface OrderDetailDefaultTableViewCell ()

@property (nonatomic, copy) NSString *btnStatus;
//@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) BaseModel *model;

@end

@implementation OrderDetailDefaultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置编号标签的圆角效果
    self.numberLabel.layer.cornerRadius = self.numberLabel.height * .5f;
    self.numberLabel.clipsToBounds = YES;
    
    // 设置接单按钮的圆角效果和阴影效果
    self.orderReceivingBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.orderReceivingBtn.layer.cornerRadius = self.orderReceivingBtn.height * 0.45;// 设置圆角效果
    self.orderReceivingBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.orderReceivingBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.orderReceivingBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.orderReceivingBtn.layer.shadowRadius = 4;// 阴影半径
    [self.orderReceivingBtn addTarget:self action:@selector(pickbtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置内容试图的边框和圆角效果
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.borderWidth = 1;
    self.contentV.layer.borderColor = [UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00].CGColor;
    
    // 设置订单类型标签的圆角和颜色
    self.orderTypeLabel.layer.cornerRadius = 3;
    self.orderTypeLabel.clipsToBounds = YES;
    self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:211 / 255.0f green:47 / 255.0f blue:47 / 255.0f alpha:1.0];
    
    // 设置支付状态标签的圆角和颜色
    self.payStatusLabel.layer.cornerRadius = 3;
    self.payStatusLabel.clipsToBounds = YES;
    self.payStatusLabel.backgroundColor = [UIColor colorWithRed:239 / 255.0f green:83 / 255.0f blue:80 / 255.0f alpha:1.0];
    //    [UIColor colorWithRed:0.93 green:0.33 blue:0.33 alpha:1.00];
    
    // 设置支付方式标签的圆角和颜色
    self.paymentLabel.layer.cornerRadius = 3;
    self.paymentLabel.clipsToBounds = YES;
    self.paymentLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.61 blue:0.63 alpha:1.00];
    
    // 设置距离标签
    self.distanceLabel.layer.cornerRadius = 3;
    self.distanceLabel.clipsToBounds = YES;
    self.distanceLabel.backgroundColor = [UIColor colorWithRed:244 / 255.0f green:143 / 255.0f blue:177 / 255.0f alpha:1.0];
    
    // 审核标签
    self.checkLabel.layer.cornerRadius = 3;
    self.checkLabel.clipsToBounds = YES;
//    self.checkLabel.text = @"已完成";
    self.checkLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:190 / 255.0f blue:231 / 255.0f alpha:1.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.lookRouteLabel.userInteractionEnabled = YES;
    [self.lookRouteLabel addGestureRecognizer:tap];
    
    [self.defaultPrice addTarget:self action:@selector(getDisPrice) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)getDisPrice {
    NSDictionary *dic = @{@"api":@"getDisPrice", @"version":@"1"};
    NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        if (!result.integerValue) {
            NSDictionary *dataDic = [EncryptionAndDecryption decryptionWithString:responseObject[@"data"]];
            NSLog(@"%@",dataDic);
            NSString *msg = [NSString stringWithFormat:@"起步距离为%@米，起步价为%@元，每增加%@米，跑腿费用增加%@元，如超过6000米，每增加%@米，跑腿费增加%@元",dataDic[@"longt"], dataDic[@"price"], dataDic[@"ctlong"], dataDic[@"cprice"], dataDic[@"ctlong"], dataDic[@"ctprice"]];
            NSLog(@"%@",msg);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)tap:(UITapGestureRecognizer *)tap {
//    self.lookRoute();
}

//  根据模型设置数据
- (void)setDataWithModel:(BaseModel *)model {
    
    _model = model;
    
    //    AlreadyDoneModel
    // 订单类型
    if (model.type.intValue == 1) {
        self.orderTypeLabel.text = @"帮我拿";
        self.startphone.text = @"拿货电话：";
    } else if (model.type.intValue == 2) {
        self.orderTypeLabel.text = @"帮我送";
        self.startphone.text = @"送货电话：";
    } else {
        self.orderTypeLabel.text = @"帮我买";
    }
    
    // 支付状态
    if (!model.pay_status.boolValue) {
        self.payStatusLabel.text = @"未支付";
    } else {
        self.payStatusLabel.text = @"已支付";
    }
    
    // 支付方式
    if (model.payment.intValue == 1) {
        self.paymentLabel.text = @"支付宝";
    } else if (model.payment.intValue == 2) {
        self.paymentLabel.text = @"微信";
    } else if (model.payment.intValue == 3) {
        self.paymentLabel.text = @"银联";
    } else {
        self.paymentLabel.text = @"货到付款";
    }
    
    
    self.distanceLabel.text = [NSString stringWithFormat:@"距%.2fkm",model.distance.floatValue / 1000.0];// 距离
    //    self.deliveryStatusLabel.text = @"配送中";// 配送状态
    self.orderNumberLabel.text = model.order_sn;// 订单号
    self.timeLabel.text = model.created;// 下单时间
    
    [self setAttributeStringWithModel:model];// 设置送货电话和收货电话标签的富文本显示
    [self setDialGesture];// 设置拨号手势
    
    self.distancePriceLabel.text = model.distance_price;// 跑腿费
    self.buyPriceLabel.text = model.buy_price;// 物品费
    self.bonusPriceLabel.text = model.bonus_price;// 红包费
    self.allPriceLabel.text = model.all_price;// 实付
    
    self.hopeTimeLabel.text = model.psend_time;// 期望送达时间
    self.remarkLabel.text = model.note;// 备注
    
//    self.orderReceivingBtn.hidden = YES;
    
    if (model.status.integerValue == 2) {// 已接单
        self.btnStatus = @"前往取货地点";
        [self gotoPick];// 添加前往取货地点的实现
    } else if (model.status.integerValue == 3) {// 在路上
        self.btnStatus = @"确认取货";
        [self confirmPick];// 添加确认取货的实现
    } else if (model.status.integerValue == 4) {// 正在配送
        self.btnStatus = @"确认送达";
        [self confirmDelivery];// 添加确认送达的实现
    }
    
    [self.orderReceivingBtn setTitle:_btnStatus forState:UIControlStateNormal];
    
    
    
    
}

//  设置富文本
- (void)setAttributeStringWithModel:(BaseModel *)model {
    // 富文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.start_phone];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.19 green:0.68 blue:0.91 alpha:1.00] range:NSMakeRange(0, [model.start_phone length])];// 设置文字颜色
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, [model.start_phone length])];// 设置下划线
    self.courierPhoneLabel.attributedText = attStr;// 送货电话
    
    
    NSMutableAttributedString *endStr = [[NSMutableAttributedString alloc] initWithString:model.end_phone];
    [endStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.19 green:0.68 blue:0.91 alpha:1.00] range:NSMakeRange(0, [model.end_phone length])];// 设置文字颜色
    [endStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, [model.end_phone length])];// 设置下划线
    self.userPhoneLabel.attributedText = endStr;// 收货电话

}

//  设置拨号手势
- (void)setDialGesture {
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dial:)];
    [self.courierPhoneLabel addGestureRecognizer:startTap];
    self.courierPhoneLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dial:)];
    [self.userPhoneLabel addGestureRecognizer:endTap];
    self.userPhoneLabel.userInteractionEnabled = YES;
}

//  拨号方法
- (void)dial:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (label.text) {
        
        /*
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认拨号" message:[NSString stringWithFormat:@"确认要拨打给%@吗", label.text] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 确认拨号
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",label.text]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:confirm];
        [alertC addAction:cancel];
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
        */
//        self.phone = label.text;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认拨号" message:[NSString stringWithFormat:@"确认要拨打给%@吗", label.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alert show];
        
        // 确认拨号
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",label.text]];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
    
    
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
//    
//    
//    if (buttonIndex == 1) {
//        // 确认拨号
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.phone]];
//        [[UIApplication sharedApplication] openURL:url];
//    }
//    
//}

- (void)setBtnBlockWithModel:(BaseModel *)model {
    if (model.status.integerValue == 2) {// 已接单
        self.btnStatus = @"前往取货地点";
        [self gotoPick];// 添加前往取货地点的实现
    } else if (model.status.integerValue == 3) {// 在路上
        self.btnStatus = @"确认取货";
        [self confirmPick];// 添加确认取货的实现
    } else if (model.status.integerValue == 4) {// 正在配送
        self.btnStatus = @"确认送达";
        [self confirmDelivery];// 添加确认送达的实现
    }
    [self.orderReceivingBtn setTitle:self.btnStatus forState:UIControlStateNormal];
}

//  取货按钮方法
- (void)pickbtn {
    
    self.orderReceivingBtn.userInteractionEnabled = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.btnStatus message:[NSString stringWithFormat:@"确定%@吗?",self.btnStatus] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (buttonIndex == 1) {
        self.request();
    }
    
}

//  给block添加前往取货地点的实现
- (void)gotoPick {
    
    OrderDetailDefaultTableViewCell *cell = self;
    
    self.request = ^ {
        
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            
            NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
            NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
            if ([latitude isEqualToString:@"20"] || [longitude isEqualToString:@"20"]) {// 已开启定位功能
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSDictionary *dic = @{@"api":@"start", @"version":@"1",@"pid":[[CourierInfoManager shareInstance] getCourierPid], @"order_sn":cell.model.order_sn};
                NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
                AFHTTPSessionManager *session  = [AFHTTPSessionManager manager];
                [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject = %@",responseObject);
                    NSNumber *result = responseObject[@"status"];
                    if (!result.integerValue) {
                        NSLog(@"前往取货地点成功");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"前往取货地点失败");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error is %@",error);
                }];
            }
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    };
}

//  给block添加确认取货的实现
- (void)confirmPick {
    OrderDetailDefaultTableViewCell *cell = self;
    
    self.request = ^ {
        
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            
            NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
            NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
            if ([latitude isEqualToString:@"20"] || [longitude isEqualToString:@"20"]) {// 已开启定位功能
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSDictionary *dic = @{@"api":@"arriveStart", @"version":@"1",@"pid":[[CourierInfoManager shareInstance] getCourierPid], @"order_sn":cell.model.order_sn};
                NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
                AFHTTPSessionManager *session  = [AFHTTPSessionManager manager];
                [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject = %@",responseObject);
                    NSNumber *result = responseObject[@"status"];
                    if (!result.integerValue) {
                        NSLog(@"确认取货成功");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"确认取货失败");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error is %@",error);
                }];
            }
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    };
}

//  给block添加确认送达的实现
- (void)confirmDelivery {
    OrderDetailDefaultTableViewCell *cell = self;
    self.request = ^ {
        if ([[[CourierInfoManager shareInstance] getCourierOnlineStatus] isEqualToString:@"1"]) {
            
            NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
            NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
            if ([latitude isEqualToString:@"20"] || [longitude isEqualToString:@"20"]) {// 已开启定位功能
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSDictionary *dic = @{@"api":@"end", @"version":@"1",@"pid":[[CourierInfoManager shareInstance] getCourierPid], @"order_sn":cell.model.order_sn};
                NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
                AFHTTPSessionManager *session  = [AFHTTPSessionManager manager];
                [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject = %@",responseObject);
                    NSNumber *result = responseObject[@"status"];
                    if (!result.integerValue) {
                        NSLog(@"确认送达成功");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"确认送达失败");
                        [cell.delegate orderDefaultRefreshWithMessage:cell.btnStatus status:@"失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error is %@",error);
                }];
            }
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先切换为上班状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    };
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

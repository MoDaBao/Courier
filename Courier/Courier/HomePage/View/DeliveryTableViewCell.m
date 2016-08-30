//
//  DeliveryTableViewCell.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DeliveryTableViewCell.h"
#import "AppDelegate.h"

@interface DeliveryTableViewCell ()

@property (nonatomic, strong) DeliveryModel *model;
@property (nonatomic, copy) NSString *btnStatus;
@end

@implementation DeliveryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置编号标签的圆角效果
    self.numberLabel.layer.cornerRadius = self.numberLabel.height * .5f;
    self.numberLabel.clipsToBounds = YES;
    
    // 设置接单按钮的圆角效果和阴影效果
    self.pickBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.pickBtn.layer.cornerRadius = self.pickBtn.height * 0.45;// 设置圆角效果
    self.pickBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.pickBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.pickBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.pickBtn.layer.shadowRadius = 4;// 阴影半径
    
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
    self.paymentLabel.backgroundColor = [UIColor colorWithRed:242 / 255.0f green:156 / 255.0f blue:159 / 255.0f alpha:1.0];
    
    // 设置距离标签
    self.distanceLabel.layer.cornerRadius = 3;
    self.distanceLabel.clipsToBounds = YES;
    self.distanceLabel.backgroundColor = [UIColor colorWithRed:244 / 255.0f green:143 / 255.0f blue:177 / 255.0f alpha:1.0];
    
    // 设置配送状态标签
    self.deliveryStatusLabel.layer.cornerRadius = 3;
    self.deliveryStatusLabel.clipsToBounds = YES;
    self.deliveryStatusLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0f green:190 / 255.0f blue:231 / 255.0f alpha:1.0];
    
    [self.pickBtn addTarget:self action:@selector(pickbtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView removeFromSuperview];
}

// 通过模型给cell赋值
- (void)setDataWithModel:(DeliveryModel *)model {
    
    self.model = model;
    
    // 订单类型
    if (model.type.intValue == 1) {
        self.orderTypeLabel.text = @"帮我拿";
    } else if (model.type.intValue == 2) {
        self.orderTypeLabel.text = @"帮我送";
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
    self.deliveryStatusLabel.text = @"配送中";// 配送状态
    self.orderNumberLabel.text = model.order_sn;// 订单号
    self.timeLabel.text = model.created;// 下单时间
    self.startLabel.text = model.start;// 起始地点
    self.endLabel.text = model.end;// 收货地点
    
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
    [self.pickBtn setTitle:self.btnStatus forState:UIControlStateNormal];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (buttonIndex == 1) {
        self.request();
    }
}

//  取货按钮方法
- (void)pickbtn {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.btnStatus message:[NSString stringWithFormat:@"确定%@吗?",self.btnStatus] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
    /*
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:self.btnStatus message:[NSString stringWithFormat:@"确定%@吗?",self.btnStatus] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.request();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:confirm];
    [alertC addAction:cancelAction];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
     */
}

//  给block添加前往取货地点的实现
- (void)gotoPick {
    
    DeliveryTableViewCell *cell = self;
    
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
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"前往取货地点失败");
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"失败"];
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
    DeliveryTableViewCell *cell = self;
    
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
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"确认取货失败");
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"失败"];
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
    DeliveryTableViewCell *cell = self;
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
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"成功"];
                    } else {
                        NSLog(@"确认送达失败");
                        [cell.delegate refreshWithMessage:cell.btnStatus status:@"失败"];
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

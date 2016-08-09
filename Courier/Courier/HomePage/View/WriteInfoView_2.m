//
//  WriteInfoView_2.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "WriteInfoView_2.h"

@implementation WriteInfoView_2

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight);
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    // 设置接单按钮的圆角效果和阴影效果
    self.sendBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.sendBtn.layer.cornerRadius = self.sendBtn.height * 0.45;// 设置圆角效果
    self.sendBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.sendBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.sendBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.sendBtn.layer.shadowRadius = 4;// 阴影半径
    
    [self.defaultBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.defaultStatusButton addTarget:self action:@selector(getDisPrice) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.remarkLabel.hidden = YES;
    
    self.pusherPhoneTF.delegate = self;
    self.receivingTF.delegate = self;
}

- (void)click {
    self.isChoose = !self.isChoose;
    [self changeDefaultStatus];
    
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
            NSString *msg = [NSString stringWithFormat:@"起步距离为%@，起步价为%@元，每增加%@米，跑腿费用增加%@元，如超过6000米，每增加%@米，跑腿费增加%@元",dataDic[@"longt"], dataDic[@"price"], dataDic[@"ctlong"], dataDic[@"cprice"], dataDic[@"ctlong"], dataDic[@"ctprice"]];
            NSLog(@"%@",msg);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  修改按钮状态
- (void)changeDefaultStatus {
    if (self.isChoose) {
        [self.defaultStatusBtn setBackgroundImage:[UIImage imageNamed:@"choosered"] forState:UIControlStateNormal];
        self.startTF.text = @"";
        self.endTF.text = @"";
        if ([self.delegate respondsToSelector:@selector(clearLatitudeAndLongitude)]) {
            [self.delegate clearLatitudeAndLongitude];
        }
//        self.startBtn.enabled = NO;
//        self.endBtn.enabled = NO;
        
    } else {
        [self.defaultStatusBtn setBackgroundImage:[UIImage imageNamed:@"choosegary"] forState:UIControlStateNormal];
//        self.startBtn.enabled = YES;
//        self.endBtn.enabled = YES;
    }
}

- (void)setDataWithModel:(BaseModel *)model {
    self.isChoose = NO;
    [self changeDefaultStatus];
    // 订单类型
    if (model.type.intValue == 1) {
        self.startLabel.text = @"拿货地址：";
    } else if (model.type.intValue == 2) {
        self.startLabel.text = @"送货地址：";
    } else {
        self.startLabel.text = @"买货地址：";
        //        self.remarkLabel.hidden = NO;
    }
}


#pragma mark -----TextField Delegate-----

// 限制输入位数11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text, string];
    NSLog(@"length = %ld, str = %@, text = %@, replace = %@",str.length, str, textField.text, string);
    if (str.length > 11) {
        return NO;
    }
    return YES;
}

@end

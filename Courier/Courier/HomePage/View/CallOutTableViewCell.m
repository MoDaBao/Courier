//
//  CallOutTableViewCell.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/16.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CallOutTableViewCell.h"

@implementation CallOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [UIColor whiteColor];
    
    // 设置订单类型标签的圆角和颜色
    self.orderTypeLabel.layer.cornerRadius = 3;
    self.orderTypeLabel.clipsToBounds = YES;
    self.orderTypeLabel.backgroundColor = [UIColor colorWithRed:211 / 255.0f green:47 / 255.0f blue:47 / 255.0f alpha:1.0];
    
    // 设置支付状态标签的圆角和颜色
    self.payStatusLabel.layer.cornerRadius = 3;
    self.payStatusLabel.clipsToBounds = YES;
    self.payStatusLabel.backgroundColor = [UIColor colorWithRed:239 / 255.0f green:83 / 255.0f blue:80 / 255.0f alpha:1.0];
    
    // 设置接单按钮的圆角效果和阴影效果
    self.orderReceivingBtn.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
    self.orderReceivingBtn.layer.cornerRadius = self.orderReceivingBtn.height * 0.45;// 设置圆角效果
    self.orderReceivingBtn.layer.shadowColor = [UIColor blackColor].CGColor;// 设置阴影颜色
    self.orderReceivingBtn.layer.shadowOffset = CGSizeMake(1, 1);// 阴影范围
    self.orderReceivingBtn.layer.shadowOpacity = .5;// 阴影透明度
    self.orderReceivingBtn.layer.shadowRadius = 4;// 阴影半径
    
    // 设置内容试图的边框和圆角效果
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.borderWidth = 1;
    self.contentV.layer.borderColor = [UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00].CGColor;
    
    [self.orderReceivingBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView removeFromSuperview];
}

- (void)btnClick {
    self.click();
}

- (void)setDataWithModel:(WaitOrdrReceivingModel *)model {
    self.orderNumberLabel.text = model.order_sn;
    self.timeLabel.text = model.created;
    self.phoneLabel.text = model.userphone;
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
    CallOutTableViewCell *cell = self;
    self.click = ^(void) {
       
        // 接单按钮
        NSDictionary *dic = @{@"api":@"singleorder", @"version":@"1", @"order_sn":model.order_sn, @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"phone":[[CourierInfoManager shareInstance] getCourierPhone]};
        NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
        NSString *parameter = [EncryptionAndDecryption encryptionWithDic:dic];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:REQUESTURL parameters:@{@"key":parameter} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            NSNumber *result = responseObject[@"status"];
            NSString *msg = nil;
            
            if (!result.integerValue) {
                msg = @"接单成功";
            } else {
                msg = responseObject[@"msg"];
            }
            NSLog(@"%@",msg);
            cell.orderRcceiving(msg);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error is %@",error);
        }];
    };
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        self.backgroundColor = [UIColor lightGrayColor];
//        
//        self.horizontalMargin = 20;
//        self.verticalMargin = 15;
//        self.contentV = [[UIView alloc] initWithFrame:CGRectMake(self.horizontalMargin, self.verticalMargin, kScreenWidth - self.horizontalMargin * 2, self.height - self.verticalMargin * 2)];// 150此处应当为当前cell的高度
//        self.contentV.layer.cornerRadius = 5;
//        self.contentV.layer.borderWidth = 1;
//        self.contentV.layer.borderColor = [UIColor colorWithRed:0.72 green:0.03 blue:0.07 alpha:1.00].CGColor;
//        [self.contentView addSubview:self.contentV];
//        
//        // 订单号
////        UILabel *orderLabel = [UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//        
//        // 下单时间
//        
//    }
//    return self;
//}

@end

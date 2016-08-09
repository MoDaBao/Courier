//
//  OrderView.m
//  Courier
//
//  Created by 莫大宝 on 16/7/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, self.note.height + self.note.y + 10);
    
    float sortaPixel =1.0/[UIScreen mainScreen].scale;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,self.note.y + self.note.height + 10 - sortaPixel,kScreenWidth, sortaPixel)];
    line.backgroundColor = [UIColor colorWithRed:193  / 255.0 green:26 / 255.0 blue:32 / 255.0 alpha:1.0];
    [self addSubview:line];//线是否加
}

- (void)setDataWithModel:(BaseModel *)model {
    self.start.text = model.start;
    self.end.text = model.end;
    self.time.text = [NSString stringWithFormat:@"时间：%@",model.created];
    NSString *status = nil;
    switch ([model.status integerValue])
    {
        case 0:
            status = @"取消订单";
            break;
        case 1:
            status= @"取消订单";
            break;
        case 2:
            status = @"已接单";
            break;
        case 3:
            status = @"正在路上";
            break;
        case 4:
            status= @"正在配送";
            break;
        case 5:
            status = @"已送达";
            break;
        case 6:
            status = @"已完成";
            break;
        case 7:
            status = @"正在退款";
            break;
        case 8:
            status = @"已取消";
            break;
        case 9:
            status = @"未填单";
            break;
        case 10:
            status = @"审核中";
            break;
            
        default:
            break;
    }
    self.status.text = [NSString stringWithFormat:@"状态：%@",status];
    self.note.text = [NSString stringWithFormat:@"备注：%@",!model.note ? @"" : model.note];
}

@end

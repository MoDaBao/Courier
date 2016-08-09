//
//  TodayInfoView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/22.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TodayInfoView.h"
#import "TodayInfoItemVIew.h"

@interface TodayInfoView ()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation TodayInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        self.dataArray = [NSMutableArray array];
////        [_dataArray addObject:@"今日有效单"];
////        [_dataArray addObject:@"今日里程"];
////        [_dataArray addObject:@"在线支付跑腿费"];
////        [_dataArray addObject:@"货到付款跑腿费"];
////        [_dataArray addObject:@"在线支付物品费"];
////        [_dataArray addObject:@"货到付款物品费"];
//        
//    }
//    return _dataArray;
//}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray {
    if (self = [super initWithFrame:frame]) {
        
        self.dataArray = dataArray;
        
        // 总行数
        NSInteger totalRow = 3;
        // 总列数
        NSInteger totalColumn = 2;
        // 水平方向上的间距
        CGFloat horizontalMargin = 20;
        // 垂直方向上的间距
        CGFloat verticalMargin = 15;
        // 宽
        CGFloat width = (self.width - horizontalMargin * 2) / totalColumn;
        // 高
        CGFloat height = self.height / totalRow;
        for (NSInteger i = 0; i < totalRow * totalColumn; i ++) {
            //计算行号
            NSInteger row = i / totalColumn;
            NSInteger col = i % totalColumn;
            TodayInfoItemView *view = [[TodayInfoItemView alloc] initWithFrame:CGRectMake(horizontalMargin + col * width, row * height, width, height) title:[[self.dataArray[i] allKeys] firstObject] value:[[dataArray[i] allValues] firstObject]];
            [self addSubview:view];
        }
        
        // 中间竖线
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(self.width * .5, verticalMargin, 1, self.height - verticalMargin * 2)];
        middleLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];
        [self addSubview:middleLine];
        
        // 横向上横线
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(horizontalMargin, height, self.width - horizontalMargin * 2, 1)];
        upLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];
        [self addSubview:upLine];
        
        // 横向下横线
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(horizontalMargin, height * 2, self.width - horizontalMargin * 2, 1)];
        downLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];
        [self addSubview:downLine];
        
        // 顶部横线
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];
        [self addSubview:topLine];
        
        // 底部横线
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];
        [self addSubview:bottomLine];
    }
    return self;
}

@end

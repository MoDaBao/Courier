//
//  HomePageView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "HomePageView.h"
#import "HomePageItemView.h"
#import "WaitOrderReceivingViewController.h"


@interface HomePageView ()

@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation HomePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)sourceArray {
    if (!_sourceArray) {
        self.sourceArray = [NSMutableArray array];
        [_sourceArray addObject:@{@"待接单":@"Alarm"}];
        [_sourceArray addObject:@{@"配送中":@"Battery car"}];
        [_sourceArray addObject:@{@"需填单":@"needwrite"}];
        [_sourceArray addObject:@{@"等待审核":@"seal"}];
        [_sourceArray addObject:@{@"已完成":@"bulb"}];
        [_sourceArray addObject:@{@"今日统计":@"todayDone"}];
    }
    return _sourceArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor orangeColor];
        
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
            HomePageItemView *itemView = [[HomePageItemView alloc] initWithFrame:CGRectMake(horizontalMargin + col % totalColumn * width, row % totalRow * height, width, height) icon:[UIImage imageNamed:[self.sourceArray[i] allValues].firstObject] itemText:[self.sourceArray[i] allKeys].firstObject];
            [itemView setTag:1000 + i];
//            itemView.backgroundColor = [UIColor lightGrayColor];
//            NSLog(@"%@",[self.sourceArray[i] allKeys].firstObject);
            [self addSubview:itemView];
        }
        
        // 中间竖线
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(self.width * .5, verticalMargin, 1, self.height - verticalMargin * 2)];
        middleLine.backgroundColor = [UIColor colorWithRed:0.79 green:0.10 blue:0.16 alpha:1.00];        [self addSubview:middleLine];
        
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

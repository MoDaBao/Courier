//
//  TipMessageView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/28.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TipMessageView.h"

@interface TipMessageView()


//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TipMessageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame tip:(NSString *)tip {
    if (self = [super initWithFrame:frame]) {
        self.alpha = .0;
        self.layer.cornerRadius = 10;
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        tipLabel.text = tip;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];
        
        
        [UIView animateWithDuration:.4 animations:^{
            self.alpha = .4;
        } completion:^(BOOL finished) {
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(hide) userInfo:nil repeats:NO];
            [self hide];
        }];
        
    }
    return self;
}

- (void)hide {
    [UIView animateWithDuration:.4 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//        [self.timer invalidate];
//        self.timer = nil;
    }];
}


@end

//
//  HomePageItemView.m
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "HomePageItemView.h"
#define kScale (13 * 1.0 / 65)// 图标的高度相对于整个view的比例

@implementation HomePageItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon itemText:(NSString *)itemText {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat margin = 15;
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.height = self.height * kScale;
        CGFloat scale = icon.size.width * 1.0 / icon.size.height;// 图片的宽高比
        self.iconImageView.width = self.iconImageView.height * scale;;
        self.iconImageView.y = self.height * .5 - self.iconImageView.height * .5;
        self.iconImageView.x = 30;
        self.iconImageView.image = icon;
        [self addSubview:self.iconImageView];
        
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.height = self.height;
        self.itemLabel.y = 0;
        self.itemLabel.x = self.iconImageView.x + self.iconImageView.width + margin;
        self.itemLabel.width = self.width - self.itemLabel.x;
        self.itemLabel.textAlignment = NSTextAlignmentLeft;
        self.itemLabel.text = itemText;
        self.itemLabel.font = [UIFont systemFontOfSize:17 * kScaleForText];
        [self addSubview:self.itemLabel];
        
        // 角标
        self.rightMark = [[UILabel alloc] initWithFrame:CGRectMake([UILabel getWidthWithTitle:itemText font:self.itemLabel.font] - 5, self.itemLabel.height * .5 - 18, 15, 15) ];
        self.rightMark.text = @"未";
        self.rightMark.textColor = [UIColor whiteColor];
        self.rightMark.font = [UIFont systemFontOfSize:12];
        self.rightMark.textAlignment = NSTextAlignmentCenter;
        self.rightMark.backgroundColor = [UIColor colorWithRed:193 / 255.0f green:26 / 255.0f blue:32 / 255.0f alpha:1.0];
        self.rightMark.layer.cornerRadius = self.rightMark.height * .5;
        self.rightMark.clipsToBounds = YES;
        [self.itemLabel addSubview:self.rightMark];
        self.rightMark.hidden = YES;
        
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.frame = CGRectMake(0, 0, self.width, self.height);
        [clickBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickBtn];
        
    }
    return self;
}

- (void)click {
    self.clickBlock();
}

@end;

//
//  TableHeaderView.m
//  Courier
//
//  Created by 莫大宝 on 16/8/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TableHeaderView.h"

@interface TableHeaderView ()


@property (nonatomic, assign) BOOL isExpansion;// 是否是展开当前tableView YES显示点击收起|NO显示点击展开
@property (nonatomic, assign) BOOL isNeedExpansion;


@end


@implementation TableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleL = [[UILabel alloc] init];
//        NSString *title = @"直接送的单子";
        titleL.text = title;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat titleW = [UILabel getWidthWithTitle:title font:font];
        CGFloat titleH = [UILabel getHeightWithTitle:title font:font];
        CGFloat titleX = (self.width - titleW) * .5;
        CGFloat titleY = (self.height - titleH) * .5;
        titleL.frame = CGRectMake(titleX, titleY, titleW, titleH);
        titleL.font = font;
        [self addSubview:titleL];
        
        CGFloat imageW = 20;
        CGFloat imageH = imageW;
        CGFloat margin = 10;
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleX - imageW - margin, (self.height - imageH) * .5, imageW, imageH)];
        if ([title isEqualToString:@"直接送的单子"]) {
            leftImage.image = [UIImage imageNamed:@"djd_car"];
            self.tag = 23333;
        } else {
            leftImage.image = [UIImage imageNamed:@"djd_pen"];
            self.tag = 66666;
        }
        
        [self addSubview:leftImage];
        
        _rightImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightImage.frame = CGRectMake(titleX + titleW + margin, (self.height - imageH) * .5, imageW, imageH);
        [_rightImage setImage:[UIImage imageNamed:@"djd_down"] forState:UIControlStateNormal];
//        [_rightImage addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightImage];
        
        
        NSString *expansion = @"(点击展开)";
        UIFont *efont = [UIFont systemFontOfSize:12];
        CGFloat expansionW = [UILabel getWidthWithTitle:expansion font:efont];
        CGFloat expansionH = [UILabel getHeightWithTitle:title font:efont];
        CGFloat expansionX = _rightImage.x + _rightImage.width;
        CGFloat expansionY = (self.height - expansionH) * .5;
        _expansion = [[UILabel alloc] initWithFrame:CGRectMake(expansionX, expansionY, expansionW, expansionH)];
        _expansion.font = efont;
        _expansion.text = expansion;
        _expansion.textColor = [UIColor lightGrayColor];
        [self addSubview:_expansion];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_rightImage.x, _rightImage.y, _rightImage.width + _expansion.width, _rightImage.height);
        [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        
        _isExpansion = NO;
        _isNeedExpansion = NO;
        
        UIImageView *lineup = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        lineup.image = [UIImage imageNamed:@"djd_line"];
        [self addSubview:lineup];
        
        UIImageView *linedown = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        linedown.image = [UIImage imageNamed:@"djd_line"];
        [self addSubview:linedown];
        
        
    }
    return self;
}

- (void)change {
    if (self.tag == 23333) {
        _isExpansion = !_isExpansion;
//        if (_isExpansion) {
//            [_rightImage setImage:[UIImage imageNamed:@"djd_up"] forState:UIControlStateNormal];
//            _expansion.text = @"(点击收起)";
//        } else {
//            [_rightImage setImage:[UIImage imageNamed:@"djd_down"] forState:UIControlStateNormal];
//            _expansion.text = @"(点击展开)";
//        }
        
        if ([self.delegate respondsToSelector:@selector(reloadTableViewWithExpansion:tag:view:)]) {
            [self.delegate reloadTableViewWithExpansion:_isExpansion tag:self.tag view:self];
        }
    } else {
        _isNeedExpansion = !_isNeedExpansion;
//        if (_isNeedExpansion) {
//            [_rightImage setImage:[UIImage imageNamed:@"djd_up"] forState:UIControlStateNormal];
//            _expansion.text = @"(点击收起)";
//        } else {
//            [_rightImage setImage:[UIImage imageNamed:@"djd_down"] forState:UIControlStateNormal];
//            _expansion.text = @"(点击展开)";
//        }
        
        if ([self.delegate respondsToSelector:@selector(reloadTableViewWithExpansion:tag:view:)]) {
            [self.delegate reloadTableViewWithExpansion:_isNeedExpansion tag:self.tag view:self];
        }
    }
    
    
}

@end

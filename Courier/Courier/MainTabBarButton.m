//
//  MainTabBarButton.m
//  cmbfaeApp
//
//  Created by 莫大宝 on 16/6/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MainTabBarButton.h"


//image ratio
#define TabBarImageRatio 0.4
#define TabBarTitleRation .6

@interface MainTabBarButton ()


@end


@implementation MainTabBarButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //只需要设置一次的放置在这里
        self.imageView.contentMode = UIViewContentModeRight;
//        self.imageView.backgroundColor = [UIColor redColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
//        self.titleLabel.backgroundColor = [UIColor orangeColor];
        [self setTitleColor:[UIColor colorWithRed:0.83 green:0.13 blue:0.10 alpha:1.00] forState:UIControlStateSelected];

        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.imageView.backgroundColor = [UIColor redColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];

    }
    return self;
}


//重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted {
    
}

// 修改self.imageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width * TabBarImageRatio;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(0, 0, imageW, imageH);
}

// 修改self.titleLabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleW = contentRect.size.width * TabBarTitleRation;
    CGFloat titleH = contentRect.size.height;
    
    return CGRectMake(contentRect.size.width * TabBarImageRatio + 5, 0, titleW, titleH);
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
}

@end

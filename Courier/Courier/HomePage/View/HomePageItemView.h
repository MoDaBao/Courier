//
//  HomePageItemView.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

@interface HomePageItemView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;// 图标
@property (nonatomic, strong) UILabel *itemLabel;// 标题标签
@property (nonatomic, copy) ClickBlock clickBlock;// 单击此Item的时候执行的block
/**
 * 右上角标
 */
@property (nonatomic, strong) UILabel *rightMark;

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon itemText:(NSString *)itemText;

@end

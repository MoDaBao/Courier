//
//  TableHeaderView.h
//  Courier
//
//  Created by 莫大宝 on 16/8/15.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableHeaderView;

@protocol TableHeaderViewDelegate <NSObject>

- (void)reloadTableViewWithExpansion:(BOOL)isExpansion tag:(NSInteger)tag view:(TableHeaderView *)view;
- (void)headerChange;

@end

@interface TableHeaderView : UIView

@property (nonatomic, assign) id<TableHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIButton *rightImage;
@property (nonatomic, strong) UILabel *expansion;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;


@end

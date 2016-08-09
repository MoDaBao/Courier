//
//  MessageBarButton.h
//  Courier
//
//  Created by 莫大宝 on 16/7/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageBarButtonDelegate <NSObject>

- (void)messageBarButtonChat;
- (void)messageBarButtonNav;

@end

typedef void (^ClickBlock)(void);
@interface MessageBarButton : UIView
@property (nonatomic, copy) ClickBlock click;

@property (nonatomic, strong) UIImageView *oneMark;

@property (nonatomic, assign) id<MessageBarButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

@end

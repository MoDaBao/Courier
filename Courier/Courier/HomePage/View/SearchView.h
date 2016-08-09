//
//  SearchView.h
//  Courier
//
//  Created by 莫大宝 on 16/7/14.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void)confirm;
- (void)searchWithStr:(NSString *)str;
- (void)edit;
- (void)end;

@end


typedef void(^ConfirmBlock)(void);
typedef void(^SearchBlock)(NSString *);
typedef void(^TableEditBlock)(void);
typedef void(^TableEndBlock)(void);

@interface SearchView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mainAddress;
@property (weak, nonatomic) IBOutlet UITextField *submitAddress;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, copy) ConfirmBlock confirm;
@property (nonatomic, copy) SearchBlock search;
@property (nonatomic, copy) TableEditBlock edit;
@property (nonatomic, copy) TableEndBlock end;
@property (nonatomic, assign) id<SearchViewDelegate> delegate;


@end

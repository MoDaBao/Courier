//
//  SearchMapViewController.h
//  Courier
//
//  Created by 莫大宝 on 16/7/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@protocol SearchMapViewControllerDelegate <NSObject>

//- (void)pushValue:(NSString *)value clickedTextFiled:(UITextField *)tf;

- (void)pushAddress:(NSString *)address latitude:(NSString *)latitude longitude:(NSString *)longitude clickedTextFiled:(UITextField *)tf;;

@end

@interface SearchMapViewController : UIViewController

@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, assign) id<SearchMapViewControllerDelegate>delegate;

@property (nonatomic, strong) UITextField *clickedTF;

@end

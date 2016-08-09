//
//  OrderDefaultView.h
//  Courier
//
//  Created by 莫大宝 on 16/7/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface OrderDefaultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *note;


- (void)setDataWithModel:(BaseModel *)model;

@end

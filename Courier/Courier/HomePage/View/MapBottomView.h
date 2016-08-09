//
//  MapBottomView.h
//  Courier
//
//  Created by 莫大宝 on 16/7/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *startPhone;

@property (weak, nonatomic) IBOutlet UILabel *endPhone;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

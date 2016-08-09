//
//  SearchTableViewCell.h
//  Courier
//
//  Created by 莫大宝 on 16/7/14.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (weak, nonatomic) IBOutlet UILabel *current;

- (void)setDataWithModel:(AMapTip *)model;
- (void)setDataWithPOI:(AMapPOI *)poi;

@end

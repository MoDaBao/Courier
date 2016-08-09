//
//  SearchTableViewCell.m
//  Courier
//
//  Created by 莫大宝 on 16/7/14.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataWithModel:(AMapTip *)model {
    self.addressLabel.text = model.name;
    self.submitLabel.text = model.address;
    
}

- (void)setDataWithPOI:(AMapPOI *)poi {
    self.addressLabel.text = poi.name;
    self.submitLabel.text = poi.address;
}

@end

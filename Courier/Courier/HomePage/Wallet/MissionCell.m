//
//  MissionCell.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MissionCell.h"

@implementation MissionCell

- (void)awakeFromNib {
    
    
    self.bgview.layer.borderColor = [UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1].CGColor;
    self.bgview.layer.borderWidth = 1;
    self.bgview.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

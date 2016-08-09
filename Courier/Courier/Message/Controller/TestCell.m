//
//  TestCell.m
//  Courier
//
//  Created by 莫大宝 on 16/7/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        imageV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imageV];
    }
    return self;
    
    
}


@end

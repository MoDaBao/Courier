//
//  PhotoCell.h
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/19.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textTF;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *img;


@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *xiangji;
@property (weak, nonatomic) IBOutlet UILabel *xuanze;



@end

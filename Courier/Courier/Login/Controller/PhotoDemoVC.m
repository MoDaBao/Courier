//
//  PhotoDemoVC.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/19.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "PhotoDemoVC.h"
#import "PhotoDemoCell.h"

@interface PhotoDemoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_table;
}
@end

@implementation PhotoDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"示例说明";
    
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    self.navigationController.navigationBar.translucent = NO;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        PhotoDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoDemoCell_1"];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PhotoDemoCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1、在拍摄证件时，确保图片清晰（证件底纹、字体、人物照片、头像清晰），无模糊，无白光点等。\n2、请拍摄证件的原件，照片必须为彩色图片，不支持扫描件。\n3、确保身份证边角显示完整。\n4、身份证需要在有效期内。\n5、申请人所填写的真实姓名、身份证号码必须与提交的证件信息一致。"]];
        
        UIColor *colo = [UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00];
        [noteStr addAttribute:NSForegroundColorAttributeName value:colo range:NSMakeRange(11, 4)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:colo range:NSMakeRange(54, 2)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:colo range:NSMakeRange(86, 2)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:colo range:NSMakeRange(98, 4)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:colo range:NSMakeRange(131, 4)];
        
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:12];
        
        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [noteStr length])];

        [cell.textTF setAttributedText:noteStr];
//        cell.textTF.text = [NSString stringWithFormat:@""];
        
        return cell;
    }
    else
    {
        PhotoDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoDemoCell_2"];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PhotoDemoCell" owner:nil options:nil];
            cell = array[1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 269;
    }
    else
    {
        return 283;
    }
}


@end

//
//  ApplyViewController.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/18.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "ApplyViewController.h"
#import "CarTypeVC.h"
#import "CommitPhotoVC.h"
#import "SettingDetailVC.h"

@interface ApplyViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    BOOL _isSelect;
    NSArray *_array;
    NSArray *_arrayImg;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *tiaoliBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UIImageView *img_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;
@property (weak, nonatomic) IBOutlet UIImageView *img_4;
@property (weak, nonatomic) IBOutlet UIImageView *img_5;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation ApplyViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.carTypeStr length] != 0)
    {
        [self.chooseBtn setTitle:[_array objectAtIndex:[self.carTypeStr integerValue] - 1] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:[_arrayImg objectAtIndex:[self.carTypeStr integerValue] - 1]] forState:UIControlStateNormal];
        self.img_5.hidden = NO;
        self.img_5.image = [UIImage imageNamed:@"ture_gou.png"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"申请成为配送员";
    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
//    self.navigationController.navigationBar.translucent = NO;
    
    self.commitBtn.layer.cornerRadius = 20;
    self.commitBtn.clipsToBounds = YES;
    
    self.chooseBtn.layer.cornerRadius = 8;
    self.chooseBtn.clipsToBounds = YES;
    self.chooseBtn.layer.borderWidth = 1;
    self.chooseBtn.layer.borderColor = [[[UIColor alloc] initWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] CGColor];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    _array = [NSArray arrayWithObjects:@"电动车",@"三轮车",@"摩托车",@"货车", nil];
    _arrayImg = [NSArray arrayWithObjects:@"1-0-2-6diandongche_1.png",@"1-0-2-9sanlunche_1.png",@"1-0-2-8motuoche_1.png",@"1-0-2-7huoche_1.png", nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.img_1.hidden = YES;
    self.img_2.hidden = YES;
    self.img_3.hidden = YES;
    self.img_4.hidden = YES;
    self.img_5.hidden = YES;
    
    if (self.view.frame.size.height < 570)
    {
        self.scroll.contentSize = CGSizeMake(0, self.view.frame.size.height + 150);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    [self.scroll addGestureRecognizer:tap];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"申请条例"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:193/255.0 green:26/255.0 blue:32/255.0 alpha:1] range:strRange];
    [self.tiaoliBtn setAttributedTitle:str forState:UIControlStateNormal];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
        return NO;
    } else {
        return YES;
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)chooseButtonClick:(UIButton *)sender
{
    CarTypeVC *VC = [[CarTypeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (BOOL)cartIdWithidentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

//限制字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1)
    {
        self.img_1.hidden = YES;
            return YES;
    }
    else if (textField.tag == 2)
    {
        self.img_2.hidden = YES;
        if (range.location >= 11)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField.tag == 3)
    {
        self.img_3.hidden = YES;
        if (range.location >= 18)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        self.img_4.hidden = YES;
        if (range.location >= 18)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}
- (BOOL) validateUserPhone : (NSString *) str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
		  
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        if ([textField.text length] != 0)
        {
            self.img_1.image = [UIImage imageNamed:@"ture_gou.png"];
        }
        else
        {
            self.img_1.image = [UIImage imageNamed:@"wrong_cal.png"];
        }
        self.img_1.hidden = NO;
    }
    else if (textField.tag == 2)
    {
        self.img_2.hidden = NO;
        
        
        if ([self validateUserPhone:textField.text])
        {
            self.img_2.image = [UIImage imageNamed:@"ture_gou.png"];
        }
        else
        {
            self.img_2.image = [UIImage imageNamed:@"wrong_cal.png"];
        }
    }
    else if (textField.tag == 3)
    {
        self.img_3.hidden = NO;
        if ([textField.text length] >= 6 && [textField.text length] <= 18)
        {
            self.img_3.image = [UIImage imageNamed:@"ture_gou.png"];
        }
        else
        {
            self.img_3.image = [UIImage imageNamed:@"wrong_cal.png"];
        }
    }
    else
    {
        self.img_4.hidden = NO;
        if ([self cartIdWithidentityCard:textField.text])
        {
            self.img_4.image = [UIImage imageNamed:@"ture_gou.png"];
        }else
        {
            self.img_4.image = [UIImage imageNamed:@"wrong_cal.png"];
        }
    }
    return YES;
}


- (IBAction)commitButtonClick:(UIButton *)sender
{
    if ([self.nameTF.text length] == 0)
    {
        [self showAlertWithMes:@"请输入姓名！"];
        return;
    }
    if (![self validateUserPhone:self.phoneTF.text]) {
        [self showAlertWithMes:@"请输入合法的手机号码！"];
        return;
    }
    
    if (![self cartIdWithidentityCard:self.idNumberTF.text])
    {
        [self showAlertWithMes:@"请输入有效的身份证号码！"];
        return;
    }
    
    if ([self.carTypeStr length] == 0)
    {
        [self showAlertWithMes:@"请选择车型！"];
        return;
    }
//    _isSelect ＝
    CommitPhotoVC *VC = [[CommitPhotoVC alloc] init];
    VC.name = self.nameTF.text;
    VC.phone = self.phoneTF.text;
    VC.password = self.passwordTF.text;
    VC.idNumber = self.idNumberTF.text;
    VC.carType = self.carTypeStr;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)tiaoliButtonClick:(UIButton *)sender
{
    SettingDetailVC *VC = [[SettingDetailVC alloc] init];
    VC.titleStr = @"条例";
    VC.urlStr = @"http://tl.tzouyi.com";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)showAlertWithMes:(NSString *)meg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:meg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}


- (IBAction)openUrl:(UIButton *)sender
{
    SettingDetailVC *VC = [[SettingDetailVC alloc] init];
    VC.titleStr = @"条例";
    VC.urlStr = @"http://tl.tzouyi.com";
    [self.navigationController pushViewController:VC animated:YES];
    
//    NSString *urlText = [NSString stringWithFormat:@"http://tl.tzouyi.com"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

@end

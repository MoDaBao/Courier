//
//  MyDiscountVC.m
//  Courier
//
//  Created by 朱玉涵 on 16/8/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MyDiscountVC.h"

@interface MyDiscountVC ()
{
    
}
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;

@property (weak, nonatomic) IBOutlet UILabel *titlePickerLab;
@property (weak, nonatomic) IBOutlet UIView *pickerDate;
@property (weak, nonatomic) IBOutlet UIView *pickerDay;

@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation MyDiscountVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wodehuokuan];
}

//我的货款
- (void)wodehuokuan {
    NSString *token = [MyMD5 md5:[NSString stringWithFormat:@"%@MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx",[[CourierInfoManager shareInstance] getCourierPid]]];
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.0.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"_token_",token,@"_userid_",[[CourierInfoManager shareInstance] getCourierPid], @"end_time", _end_time, @"start_time", _start_time,@"userid",[[CourierInfoManager shareInstance] getCourierPid],@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    NSString *sign = [MyMD5 md5:str];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.0.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"SystemVersion",sign,@"_sign_",token,@"_token_",[[CourierInfoManager shareInstance] getCourierPid],@"_userid_", _end_time, @"end_time", _start_time, @"start_time", [[CourierInfoManager shareInstance] getCourierPid], @"userid", nil];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session POST:@"http://mapi.tzouyi.com/account/shipment" parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"message"] isEqualToString:@"success"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = responseObject[@"data"];
                self.amountLabel.text = [NSString stringWithFormat:@"我的货款：%@",dic[@"amount"]];
                self.delivery_amount.text = [NSString stringWithFormat:@"%@",dic[@"delivery_amount"]];
                self.delivery_item_amount.text = [NSString stringWithFormat:@"%@",dic[@"delivery_item_amount"]];
                self.online_pay_balance.text = [NSString stringWithFormat:@"%@",dic[@"online_pay_balance"]];
                self.order_total.text = [NSString stringWithFormat:@"%@",dic[@"order_total"]];
                self.tipLabel.text = [NSString stringWithFormat:@"%@",dic[@"tips"]];
                self.pay_amount.text = [NSString stringWithFormat:@"%@",dic[@"pay_amount"]];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的贷款";
//    self.navigationController.navigationBar.translucent = NO;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 80, 30);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"今日" forState:UIControlStateNormal];
//    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.selected = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.bigView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bigView.hidden = YES;
    
    self.dataPicker.maximumDate = [NSDate date];
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转化为字符串
    NSString *dateStr = [formatter stringFromDate:now];
    self.start_time = dateStr;
    self.end_time = dateStr;
    
    
    UITapGestureRecognizer *hiddenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTap)];
    [self.bigView addGestureRecognizer:hiddenTap];
    
    [self.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    self.dataPicker.datePickerMode = UIDatePickerModeDate;
    self.dataPicker.maximumDate = now;
    self.dataPicker.date = now;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *testformatter = [[NSDateFormatter alloc] init];
    [testformatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *testdateStr = [testformatter stringFromDate:newdate];
    NSLog(@"date str = %@", testdateStr);
    NSString *minDateStr = [NSString stringWithFormat:@"%@-01",testdateStr];
    self.dataPicker.minimumDate = [formatter dateFromString:minDateStr];
    
    
    
    
}

- (void)hiddenTap {
    self.bigView.hidden = YES;
}


- (void)rightBtnClick:(UIButton *)btn
{
    
    if (self.bigView.hidden) {
        self.bigView.hidden = NO;
        self.pickerDate.hidden = YES;
        self.pickerDay.hidden = NO;
    } else {
        self.bigView.hidden = YES;
    }
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 今日按钮
- (IBAction)todayClick:(id)sender {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *now = [NSDate date];
    NSDate *yesterDay = [now dateByAddingTimeInterval:-secondsPerDay];
    NSLog(@"yesterDay = %@",yesterDay);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转化为字符串
    NSString *dateStr = [formatter stringFromDate:now];
    self.start_time = dateStr;
    self.end_time = dateStr;
    [self wodehuokuan];
    self.bigView.hidden = YES;
    [_rightBtn setTitle:@"今日" forState:UIControlStateNormal];
}

// 近7日
- (IBAction)sevenDayClick:(id)sender {
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
    NSDate *date = [NSDate date];
    NSDate *sevenDayBefore = [date dateByAddingTimeInterval:-secondsPerDay];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转化为字符串
    NSString *now = [formatter stringFromDate:date];
    self.end_time = now;
    NSString *seven = [formatter stringFromDate:sevenDayBefore];
    self.start_time = seven;
    [self wodehuokuan];
    self.bigView.hidden = YES;
    [_rightBtn setTitle:@"近7日" forState:UIControlStateNormal];
}

// 近30日
- (IBAction)thrityDayClick:(id)sender {
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 30;
    NSDate *date = [NSDate date];
    NSDate *thrityBefore = [date dateByAddingTimeInterval:-secondsPerDay];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //将日期转化为字符串
    NSString *now = [formatter stringFromDate:date];
    self.end_time = now;
    NSString *thrity = [formatter stringFromDate:thrityBefore];
    self.start_time = thrity;
    [self wodehuokuan];
    self.bigView.hidden = YES;
    [_rightBtn setTitle:@"近30日" forState:UIControlStateNormal];

}

// 自定义
- (IBAction)customDayClick:(id)sender {
    self.pickerDay.hidden = YES;
    self.pickerDate.hidden = NO;
    _titlePickerLab.text = @"请选择起始日期";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cancleDateP:(UIButton *)sender
{
    self.bigView.hidden = YES;
}

- (IBAction)chooseBtn:(UIButton *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if ([_titlePickerLab.text isEqualToString:@"请选择起始日期"]) {
        _titlePickerLab.text = @"请选择截止日期";
        self.start_time = [formatter stringFromDate:self.dataPicker.date];
        self.dataPicker.date = [NSDate date];
    } else {
        self.end_time = [formatter stringFromDate:self.dataPicker.date];
        [self wodehuokuan];
        self.bigView.hidden = YES;
        [_rightBtn setTitle:@"自定义" forState:UIControlStateNormal];
    }
//    self.bigView.hidden = YES;
    
}





@end

//
//  CommitPhotoVC.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/7/19.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "CommitPhotoVC.h"
#import "PhotoDemoVC.h"
#import "PhotoCell.h"
#import "Base64.h"
#import "MyMD5.h"

@interface CommitPhotoVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *_table;
    UIImage *_imag_1;
    UIImage *_imag_2;
    UIImage *_imag_3;
    UIImage *_imag_4;
    
    NSString *_imgTitle_1;
    NSString *_imgTitle_2;
    NSString *_imgTitle_3;
    NSString *_imgTitle_4;
    
    NSInteger _imgIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation CommitPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"照片上传";
    
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
//    self.navigationController.navigationBar.translucent = NO;
    
    self.commitBtn.layer.cornerRadius = 20;
    self.commitBtn.clipsToBounds = YES;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    if ([self.carType integerValue] == 1)
    {
        return 2;
    }
    else
    {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0)
    {
        cell.img.image = [UIImage imageNamed:@"zhengmian_1.png"];
        cell.textTF.text = @"手持身份证正面";
    }
    else if (indexPath.row == 1)
    {
        cell.img.image = [UIImage imageNamed:@"beimian_1.png"];
        cell.textTF.text = @"手持身份证背面";
    }
    else if (indexPath.row == 2)
    {
        cell.img.image = [UIImage imageNamed:@"xingshizheng.png"];
        cell.textTF.text = @"行驶证";
    }
    else
    {
        cell.img.image = [UIImage imageNamed:@"jiashizheng.png"];
        cell.textTF.text = @"驾驶证";
    }
    cell.img.contentMode = UIViewContentModeScaleAspectFill;
    cell.img.clipsToBounds = YES;
    
    cell.bgImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.bgImg.clipsToBounds = YES;
    
    cell.xiangji.hidden = NO;
    cell.xuanze.hidden = NO;
    cell.textTF.hidden = NO;
    
    if (indexPath.row == 0)
    {
        if (_imag_1)
        {
            cell.bgImg.image = _imag_1;
            cell.xiangji.hidden = YES;
            cell.xuanze.hidden = YES;
            cell.textTF.hidden = YES;
        }
    }
    else if (indexPath.row == 1)
    {
        if (_imag_2)
        {
            cell.bgImg.image = _imag_2;
            cell.xiangji.hidden = YES;
            cell.xuanze.hidden = YES;
            cell.textTF.hidden = YES;
        }
    }
    else if (indexPath.row == 2)
    {
        if (_imag_3)
        {
            cell.bgImg.image = _imag_3;
            cell.xiangji.hidden = YES;
            cell.xuanze.hidden = YES;
            cell.textTF.hidden = YES;
        }
    }
    else
    {
        if (_imag_4)
        {
            cell.bgImg.image = _imag_4;
            cell.xiangji.hidden = YES;
            cell.xuanze.hidden = YES;
            cell.textTF.hidden = YES;
        }
    }
    
    cell.btn.tag = indexPath.row + 1;
    [cell.btn addTarget:self action:@selector(commitPhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

- (void)commitPhoneBtnClick:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    actionSheet.tag = btn.tag;
    _imgIndex = btn.tag;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 0)
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1)
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    switch (_imgIndex)
    {
        case 1:
            _imag_1 = image;
            break;
            
        case 2:
            _imag_2 = image;
            break;
            
        case 3:
            _imag_3 = image;
            break;
            
        case 4:
            _imag_4 = image;
            break;
            
        default:
            break;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    manager.responseSerializer= [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil]];
    
    [manager POST:[NSString stringWithFormat:@"http://mapi.tzouyi.com/base/uploadImage"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"pic" ] fileName:[NSString stringWithFormat:@"abc.png"] mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dict);
        if ([[dict objectForKey:@"message"] isEqualToString:@"success"])
        {
            switch (_imgIndex){
                case 1:
                    _imgTitle_1 = [NSString stringWithFormat:@"%@%@",[[dict objectForKey:@"data"] objectForKey:@"base_url"],[[dict objectForKey:@"data"] objectForKey:@"name"]];
                    break;
                    
                case 2:
                    _imgTitle_2 = [NSString stringWithFormat:@"%@%@",[[dict objectForKey:@"data"] objectForKey:@"base_url"],[[dict objectForKey:@"data"] objectForKey:@"name"]];
                    break;
                    
                case 3:
                    _imgTitle_3 = [NSString stringWithFormat:@"%@%@",[[dict objectForKey:@"data"] objectForKey:@"base_url"],[[dict objectForKey:@"data"] objectForKey:@"name"]];
                    break;
                    
                case 4:
                    _imgTitle_4 = [NSString stringWithFormat:@"%@%@",[[dict objectForKey:@"data"] objectForKey:@"base_url"],[[dict objectForKey:@"data"] objectForKey:@"name"]];
                    break;
                    
                default:
                    break;
            }
        }
        //
        [picker dismissViewControllerAnimated:YES completion:nil];
        //
        [_table reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (NSString *)saveImageWithImage:(UIImage *)image
{
    if (image) {
        NSString *homePath = NSHomeDirectory();
        NSString *imagePath = [homePath stringByAppendingPathComponent:@"tmp/headico.png"];
        [UIImageJPEGRepresentation(image,1.0) writeToFile:imagePath atomically:YES];
        NSString *faceUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFO_FACE"];
        if (faceUrl) {
            //            [[SDImageCache sharedImageCache] removeImageForKey:faceUrl];
        }
        return imagePath;
    }else
    {
        return nil;
    }
}

- (IBAction)demoBtnClick:(UIButton *)sender
{
    PhotoDemoVC *VC = [[PhotoDemoVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

- (IBAction)commitButtonClick:(UIButton *)sender
{
    if ([self.carType integerValue] == 1)
    {
        if ([_imgTitle_1 length] == 0 || [_imgTitle_2 length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择证件图片！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    else
    {
        if ([_imgTitle_1 length] == 0 || [_imgTitle_2 length] == 0 || [_imgTitle_3 length] == 0 ||[_imgTitle_4 length] == 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择证件图片！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@%@",@"BaseAppType",@"ios",@"BaseAppVersion",@"1.2.1",@"SystemVersion",[NSString stringWithFormat:@"iPhone_%.2f",[self getIOSVersion]],@"car_type",self.carType,@"card_opposite_image",_imgTitle_2,@"card_positive_image",_imgTitle_1,@"identity_card",self.idNumber,@"password",[MyMD5 md5:self.password],@"phone",self.phone,@"username",self.name,@"MHDnIUIlkkhNdYtIk5SAIwnYH8beRL2HlrHj5FyB0kQSxp9eurSMv9EDyXue3WYx"];
    
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"BaseAppType",@"1.2.1",@"BaseAppVersion",[NSString stringWithFormat:@"iPhone_%.2f",[self getIOSVersion]],@"SystemVersion",[MyMD5 md5:str],@"_sign_",self.carType,@"car_type",_imgTitle_2,@"card_opposite_image",_imgTitle_1,@"card_positive_image",self.idNumber,@"identity_card",[MyMD5 md5:self.password],@"password",self.phone,@"phone",self.name,@"username",nil];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain",@"text/javascript",@"application/json",@"text/json",nil]];
    
    
    
    [manager POST:[NSString stringWithFormat:@"http://mapi.tzouyi.com/%@",@"/account/addpapply"] parameters:dataDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        
        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"status"] integerValue] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的资料已成功提交，审核时间为3天，请耐心等候" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed:%@", error);
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

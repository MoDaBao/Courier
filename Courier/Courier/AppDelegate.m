//
//  AppDelegate.m
//  Courier
//
//  Created by 莫大宝 on 16/6/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "MessageViewController.h"
#import "PersonViewController.h"
#import "MainTabBarController.h"
#import "ManagerViewController.h"
#import "WaitOrderReceivingViewController.h"

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])



@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate {
    NSString *_order_sn;
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
//    [application registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(didReceiveMessageNotification2:)
//     name:RCKitDispatchMessageNotification
//     object:nil];
    
    
    
//    NSLog(@"%@",[NSString stringWithFormat:@"user_%@",USER_ID]);
    
//    [JPUSHService setAlias:[NSString stringWithFormat:@"user_%@",USER_ID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    // 极光初始化
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    
    // 高德SDK 配置用户Key
    [AMapServices sharedServices].apiKey = @"c34ce3eddc215c53b4f2102ba1cdc40c";
    
    /*
    ManagerViewController *testVC = [[ManagerViewController alloc] init];
    if ([[[CourierInfoManager shareInstance] getCourierToken] isEqualToString:@" "]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        testVC.rootVC = loginVC;
    } else {
        testVC.rootVC = [[MainTabBarController alloc] init];
    }
    self.window.rootViewController = testVC;
    */
    
    MainTabBarController *mainTabVC = [[MainTabBarController alloc] init];
    self.window.rootViewController = mainTabVC;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}



// 上传跑腿位置
- (void)courierAddress {
    
    NSLog(@"上传了一次");
    
    // POST请求参数
    NSDictionary *dic = @{@"api":@"courierAddress", @"version":@"1", @"pid":[[CourierInfoManager shareInstance] getCourierPid], @"longitude":@"20", @"latitude":@"20"};
    NSLog(@"%@",[[CourierInfoManager shareInstance] getCourierPid]);
    NSString *parmeter = [EncryptionAndDecryption encryptionWithDic:dic];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:REQUESTURL parameters:@{@"key":parmeter} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            NSLog(@"上传跑腿位置失败");
        } else {
            NSLog(@"上传跑腿位置成功");
        }
//        NSLog(@"respopnseObject = %@",[responseObject class]);
//        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    
    
}



// 当得到苹果的APNs服务器返回的DeviceToken就会被调用
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
//    [JPUSHService registrationID];
//    // ＊＊＊＊＊星标1＊＊＊＊＊＊＊
//    [JPUSHService setTags:[NSSet setWithObjects:@"test", nil] alias:@"ZhangQian" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    // 使用别名标识设备
    NSString *alias = [NSString stringWithFormat:@"puser_%@",[[CourierInfoManager shareInstance] getCourierPid]];
    [JPUSHService setAlias:alias callbackSelector:nil object:nil];
    
    
    

    
    
    // ＊＊＊＊＊星标1＊＊＊＊＊＊＊
}



// 接收到远程通知，触发方法和本地通知一致
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"%@", userInfo);
//    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    
    [JPUSHService handleRemoteNotification:userInfo];// 处理收到的APNS消息
    
}

// ＊＊＊＊＊星标2＊＊＊＊＊＊＊
- (void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ntags: %@, \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\nalias: %@\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {// 点击推送消息时调用
    
    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    
//    if (application.applicationState == UIApplicationStateActive) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
//                                                            message:userInfo[@"alert"]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//        
//    }
//    
//    
//    
//    completionHandler(UIBackgroundFetchResultNewData);
    
//    NSString *title = [userInfo valueForKey:@"title"];
//    UIAlertView*aliertView = [[UIAlertView alloc]initWithTitle:title message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"前去抢单" otherButtonTitles: nil];
//    [aliertView show];
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
    
    
    
    

//    completionHandler(UIBackgroundFetchResultNoData);
    
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [JPUSHService ];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [application cancelAllLocalNotifications];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark  --极光方法--

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
    
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    [[notification userInfo] valueForKey:@"RegistrationID"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
    NSString *order_sn = contentDic[@"order_sn"];
    _order_sn = order_sn;
//    NSString *status = [userInfo valueForKey:@"status"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic2:extra]];
    NSLog(@"%@", currentContent);
//    NSDictionary *hahah = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    /*
    _order_sn = [hahah objectForKey:@"order_sn"];
    if ([_order_sn length] != 0)
    {
        //呼叫跑腿的弹框
        [[NSUserDefaults standardUserDefaults] setObject:@"XAXAXA" forKey:@"XAXAXA"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"CallRusn"];
    }
    
    //    if ()
    //    {
    RCMessage *message = notification.object;
    NSLog(@"%@",message.objectName);
    
    
    //        SimpleMessage *Msg = [SimpleMessage messageWithContent:@"test"];
    //        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
    //
    //                              targetId:@""
    //
    //                               content:Msg
    //
    //                           pushContent:nil
    //
    //                              pushData:nil
    //
    //                               success:^(long messageId) {
    //
    //                               } error:^(RCErrorCode nErrorCode, long messageId) {
    //
    //                               }];
    //    }
     
     */
    
    
   
    
    if (![[[CourierInfoManager shareInstance] getCourierPid] isEqualToString:@" "]) {
        if ([[title substringWithRange:NSMakeRange(0, 8)] isEqualToString:@"您有一个新的订单"]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber =
            [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"前去抢单" otherButtonTitles: nil];
            alert.tag = 6666;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            alert.tag = 2333;
            [alert show];
        }
    }
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 6666) {
        
        MainTabBarController *tabVC = (MainTabBarController *)self.window.rootViewController;
        WaitOrderReceivingViewController *waitVC = [[WaitOrderReceivingViewController alloc] init];
        waitVC.isJPush = YES;
        waitVC.order_sn = _order_sn;
        
        if (tabVC.selectedIndex == 0) {
            [tabVC.homeVc.navigationController pushViewController:waitVC animated:YES];
            NSMutableArray *array = [tabVC.homeVc.navigationController.viewControllers copy];
            for (NSInteger i = 0; i < array.count; i ++) {
                if (!(i == 0) && !(i == array.count - 1)) {
                    [array removeObject:array[i]];
                }
            }
            tabVC.homeVc.navigationController.viewControllers = array;
        } else if (tabVC.selectedIndex == 1) {
            [tabVC.chatListVC.navigationController pushViewController:waitVC animated:YES];
            NSMutableArray *array = [tabVC.chatListVC.navigationController.viewControllers copy];
            for (NSInteger i = 0; i < array.count; i ++) {
                if (!(i == 0) && !(i == array.count - 1)) {
                    [array removeObject:array[i]];
                }
            }
            tabVC.chatListVC.navigationController.viewControllers = array;
        } else {
            [tabVC.personVC.navigationController pushViewController:waitVC animated:YES];
            NSMutableArray *array = [tabVC.personVC.navigationController.viewControllers copy];
            for (NSInteger i = 0; i < array.count; i ++) {
                if (!(i == 0) && !(i == array.count - 1)) {
                    [array removeObject:array[i]];
                }
            }
            tabVC.personVC.navigationController.viewControllers = array;
        }
    }
    
    
    
    
    
//    self.window.rootViewController
    
   
    
//    MainTabBarController *tabVC = (MainTabBarController *)self.window.rootViewController;
//    UIViewController *vc = (UIViewController *)tabVC.selectedViewController;
//    [vc.navigationController pushViewController:waitVC animated:YES];
//    [self.window.rootViewController presentViewController:waitVC animated:YES completion:nil];
    
}


// if not ,log will be \Uxxx
- (NSString *)logDic2:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}


@end

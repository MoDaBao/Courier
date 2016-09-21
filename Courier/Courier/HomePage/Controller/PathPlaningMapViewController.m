//
//  MapViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/7/1.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PathPlaningMapViewController.h"
#import "MapBottomView.h"
#import "ChatViewController.h"
#import "MessageBarButton.h"
#import "SelectableOverlay.h"
#import "RouteCollectionViewCell.h"
#import "MapNavViewController.h"

@interface PathPlaningMapViewController ()<MAMapViewDelegate,  AMapNaviDriveManagerDelegate, AMapLocationManagerDelegate, MessageBarButtonDelegate>

@property (nonatomic, strong) MAMapView *mapView;// 地图对象

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;// 导航管理对象
//@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;

//@property (nonatomic, strong) AMapLocationManager *locationManager;

// 位置信息
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, copy) NSString *end_latitude;
@property (nonatomic, copy) NSString *end_longitude;
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *endName;

@property (nonatomic, strong) MessageBarButton *message;
@property (nonatomic, strong) MessageBarButton *nav;// 导航按钮


@end

@implementation PathPlaningMapViewController

- (NSMutableArray *)routeIndicatorInfoArray {
    if (!_routeIndicatorInfoArray) {
        self.routeIndicatorInfoArray = [NSMutableArray array];
    }
    return _routeIndicatorInfoArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建视图
- (void)createView {
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    PathPlaningMapViewController *pathVC = self;
    // 带角标的消息按钮
    _message = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"消息" font:[UIFont systemFontOfSize:13]];
    _message.delegate = self;
//    _message.click = ^ {
//        // 这里要根据订单生成一个会话
//        
//        [pathVC chat];// 调出聊天窗口
//        
//        NSLog(@"点击了消息item");
//    };
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_message];
    
    
    _nav = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"导航" font:[UIFont systemFontOfSize:13]];
    _nav.oneMark.hidden = YES;// 隐藏角标
    _nav.delegate = self;
//    _nav.click = ^ {
//        NSLog(@"导航");
//    };
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:_nav];
    self.navigationItem.rightBarButtonItems = @[messageItem, navItem];
    
    
    MapBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"MapBottomView" owner:nil options:nil] lastObject];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
    [self bottomViewSetDataWithModel:self.baseModel bottomView:bottomView];
}

- (void)messageBarButtonNav {
    NSLog(@"导航");
    NSString *sla = [NSString stringWithFormat:@"%lf",_latitude];
    NSString *slo = [NSString stringWithFormat:@"%lf",_longitude];

    NSString *urlOfSource = [@"applicationName" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&backScheme=Courier&slat=%@&slon=%@&sname=%@&sid=B001&dlat=%@&dlon=%@&dname=%@&did=B002&dev=0&m=3&t=0", urlOfSource, sla, slo, _startName, _end_latitude, _end_longitude, _endName];
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]]) {
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先安装高德地图" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
//    MapNavViewController *mapNavVC = [[MapNavViewController alloc] init];
//    
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.latitude longitude:self.longitude];
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:_end_latitude.floatValue longitude:_end_longitude.floatValue];
//    mapNavVC.startPoint = startPoint;
//    mapNavVC.endPoint = endPoint;
//    [self.navigationController pushViewController:mapNavVC animated:YES];
    
    
}

- (void)messageBarButtonChat {
    if (_baseModel.status.integerValue == 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单已完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self chat];
    }
    
}

- (void)bottomViewSetDataWithModel:(BaseModel *)model bottomView:(MapBottomView *)bottomView {
    // 订单类型
    if (model.type.intValue == 1) {
        bottomView.startLabel.text = @"拿货电话：";
    } else if (model.type.intValue == 2) {
        bottomView.startLabel.text = @"送货电话：";
    } else {
        bottomView.startLabel.text = @"买货电话：";
    }
    bottomView.startPhone.text = model.start_phone;
    bottomView.endPhone.text = model.end_phone;
    bottomView.distance.text = [NSString stringWithFormat:@"%@米",model.distance];
    
}

// 调出聊天界面
- (void)chat {
    
    //新建一个聊天会话View Controller对象ler alloc]init];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithModel:self.baseModel];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _baseModel.order_sn;
    
    //设置聊天会话界面要显示的标题
        chatVC.title = self.baseModel.userphone;
    
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"地图导航";
    
//    //初始化检索对象
//    _search = [[AMapSearchAPI alloc] init];
//    _search.delegate = self;
    
    // 地图
//    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - 110)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
//    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
//    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动

//    self.locationManager = [[AMapLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    [self.locationManager startUpdatingLocation];
    
     //路径规划
    _driveManager = [[AMapNaviDriveManager alloc] init];
    [self.driveManager setDelegate:self];

    
    AMapNaviPoint *endPoint =[AMapNaviPoint locationWithLatitude:self.baseModel.end_latitude.doubleValue longitude:self.baseModel.end_longitude.doubleValue];
    _end_latitude = self.baseModel.end_latitude;
    _end_longitude = self.baseModel.end_longitude;
    AMapNaviPoint *startPoint = nil;
    if (_isDefault) {// 默认起送
        _latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue];
        _longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue];
        startPoint = [AMapNaviPoint locationWithLatitude:_latitude longitude:_longitude];
        // 发起逆地理编码
//        AMapReGeocodeSearchRequest *reGeo = [[AMapReGeocodeSearchRequest alloc] init];
//        reGeo.location = [AMapGeoPoint locationWithLatitude:_latitude longitude:_longitude];
//        reGeo.radius = 200;
//        reGeo.requireExtension = YES;
//        //发起逆向地理编码
//        [_search AMapReGoecodeSearch:reGeo];
    } else {
        _latitude = self.baseModel.start_latitude.doubleValue;
        _longitude = self.baseModel.start_longitude.doubleValue;
        startPoint = [AMapNaviPoint locationWithLatitude:self.baseModel.start_latitude.doubleValue longitude:self.baseModel.start_longitude.doubleValue];
//        _startName = self.baseModel.start;
//        _endName = self.baseModel.end;
        _startName = @"";
        _endName = @"";
    }
    
    // 把地图中心点设为路径规划的起点
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude)];
    
    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefaultAndFastestAndShort];
    
//    if (_isDefault) {
//        [self.driveManager calculateDriveRouteWithEndPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefaultAndFastestAndShort];
//    } else {
//        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.baseModel.start_latitude.doubleValue longitude:self.baseModel.start_longitude.doubleValue];
//        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil  drivingStrategy:AMapNaviDrivingStrategyDefaultAndFastestAndShort];
//    }

    
    [self createView];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView = nil;
    _driveManager = nil;
    _nav = nil;
    _message = nil;
}

#pragma mark -----显示路径规划路径-----

// 添加大头针
- (void)addAnnotationWithStartPoint:(AMapNaviPoint *)start endPoint:(AMapNaviPoint *)end {
    // 终点大头针
    MAPointAnnotation *endPointAnnotation = [[MAPointAnnotation alloc] init];
    endPointAnnotation.coordinate = CLLocationCoordinate2DMake(end.latitude, end.longitude);
    endPointAnnotation.title = @"终点";
    [_mapView addAnnotation:endPointAnnotation];
    
    // 起点大头针
    MAPointAnnotation *startPointAnnotation = [[MAPointAnnotation alloc] init];
    startPointAnnotation.coordinate = CLLocationCoordinate2DMake(start.latitude, start.longitude);
    startPointAnnotation.title = @"起点";
//    startPointAnnotation.
    [_mapView addAnnotation:startPointAnnotation];
}

- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
        return;
    }
    
    [_mapView removeOverlays:_mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (NSInteger i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        
        [_mapView addOverlay:selectablePolyline];
        free(coords);
        
        //更新CollectonView的信息
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)[aRoute routeStrategy]];
        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
        
        [self.routeIndicatorInfoArray addObject:info];
    }
    
    [_mapView showAnnotations:_mapView.annotations animated:NO];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

//  选择路径
- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

//  选择
- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [_mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[_mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [_mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:_mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
    
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        if ([[annotation title] isEqualToString:@"起点"]) {
            annotationView.pinColor = MAPinAnnotationColorRed;
        } else {
            annotationView.pinColor = MAPinAnnotationColorGreen;
        }
        
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //配置导航参数
        AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
        config.destination = view.annotation.coordinate;//终点坐标，Annotation的坐标
        config.appScheme = [self getApplicationScheme];//返回的Scheme，需手动设置
        config.appName = [self getApplicationName];//应用名称，需手动设置
        config.strategy = AMapDrivingStrategyShortest;
        //若未调起高德地图App,引导用户获取最新版本的
//        if(![MANavigation openAMapNavigation:config])
//        {
//            [MANavigation getLatestAMapApp];
//        }
    }
}

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}


#pragma mark - AMapNaviManagerDelegate

// 路径规划成功
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"路径规划成功");
    
    [self addAnnotationWithStartPoint:driveManager.naviRoute.routeStartPoint endPoint:driveManager.naviRoute.routeEndPoint];
    [self showNaviRoutes];
}

// 路径规划失败
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"error is %@",error);
    NSLog(@"路径规划失败");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

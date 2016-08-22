//
//  MapImagePreviewVC.m
//  RunErrands
//
//  Created by 朱玉涵 on 16/8/9.
//  Copyright © 2016年 com.WenlingOuYi.RunErrands. All rights reserved.
//

#import "MapImagePreviewVC.h"nnb
#import <MAMapKit/MAMapKit.h>

@interface MapImagePreviewVC ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation MapImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"位置信息";
    
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"redLineNew.png"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    self.navigationController.navigationBar.translucent = NO;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0,0,self.view.width,self.view.height)];
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 15;
    _mapView.userTrackingMode=MAUserTrackingModeFollow;
    _mapView.visibleMapRect = MAMapRectMake(286493216, 121418270, 2500, 2500);
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    
    MAPointAnnotation* annotation = [[MAPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    
    coor.latitude = self.locationMessage_.location.latitude;
    coor.longitude = self.locationMessage_.location.longitude;
    annotation.coordinate = coor;
    annotation.title = self.locationMessage_.locationName;
    [_mapView addAnnotation:annotation];
    
    [_mapView setCenterCoordinate:(CLLocationCoordinate2D){self.locationMessage_.location.latitude,self.locationMessage_.location.longitude}];

}

#pragma mark  -the method of mapView's delegate-
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        _mapView.showsUserLocation=NO;
        
        return poiAnnotationView;
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

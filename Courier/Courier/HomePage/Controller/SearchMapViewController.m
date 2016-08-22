//
//  SearchMapViewController.m
//  Courier
//
//  Created by 莫大宝 on 16/7/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "SearchMapViewController.h"
#import "ChatViewController.h"
#import "MapBottomView.h"
#import "MessageBarButton.h"
#import "SearchView.h"
#import "SearchTableViewCell.h"
#define tableH (kScreenHeight / 3.0)

@interface SearchMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MessageBarButtonDelegate, SearchViewDelegate> {
//    MAMapView *_mapView;// 地图对象
}

@property (nonatomic, strong) MAMapView *mapView;// 地图对象

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *poiArray;

@property (nonatomic, strong) SearchView *searchView;

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
//@property (nonatomic, copy) NSString *end_latitude;
//@property (nonatomic, copy) NSString *end_longitude;

@property (nonatomic, copy) NSString *mainAddress;
@property (nonatomic, copy) NSString *submitAddress;


@end

@implementation SearchMapViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)poiArray {
    if (!_poiArray) {
        self.poiArray = [NSMutableArray array];
    }
    return _poiArray;
}


- (void)createView {
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    // 地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, (kScreenHeight - kNavigationBarHeight) - kScreenHeight / 3.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    MessageBarButton *message = [[MessageBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20) title:@"消息" font:[UIFont systemFontOfSize:13]];
    message.delegate = self;
//    message.click = ^ {
//        // 这里要根据订单生成一个会话
//        [self chat];// 调出聊天窗口
//        NSLog(@"点击了消息item");
//    };
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    /*
    MapBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"MapBottomView" owner:nil options:nil] lastObject];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
     */
    
//    CGFloat tableH = kScreenHeight / 3.0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight - tableH, kScreenWidth, tableH) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [self.mapView addGestureRecognizer:tap];
    
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mapView.width * .5 - 6, self.mapView.height * .5 - 18, 12, 18)];
    locationView.image = [UIImage imageNamed:@"location"];
    [self.mapView addSubview:locationView];
    
    [self.mapView bringSubviewToFront:self.tableView];
    
}

- (void)messageBarButtonChat {
    
    [self chat];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView = nil;
    _search = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.00];
    self.navigationItem .title = @"地图导航";
    
    [self createView];
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    // 初始化搜索视图
    self.searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil] lastObject];
    CGFloat margin = 30;
    CGFloat searchW = kScreenWidth - margin * 2;
    self.searchView.frame = CGRectMake(margin, kNavigationBarHeight + 40, searchW, 60);
    self.searchView.delegate = self;
//    SearchMapViewController *vc = self;
//    self.searchView.confirm = ^ {
//        // 传值
//        if (!vc.latitude || !vc.longitude) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请从下列地址中选择" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        } else {
//            [vc.delegate pushAddress:[NSString stringWithFormat:@"%@%@",vc.searchView.mainAddress.text, vc.searchView.submitAddress.text] latitude:vc.latitude longitude:vc.longitude clickedTextFiled:vc.clickedTF];
//            [vc.navigationController popViewControllerAnimated:YES];
//        }
//        
//        
//    };
//    self.searchView.search = ^(NSString *keywords) {
////        if (keywords.length == 1) {
////            vc.tableView.hidden = YES;
////        } else {
////            vc.tableView.hidden = NO;
////        }
//        
//        //构造AMapInputTipsSearchRequest对象，设置请求参数
//        AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
//        tipsRequest.keywords = keywords;
//        tipsRequest.city = @"台州市";
//        
//        //发起输入提示搜索
//        [vc.search AMapInputTipsSearch: tipsRequest];
//    };
//    self.searchView.edit = ^ {
//        vc.tableView.height = tableH * 2;
//        vc.tableView.y = kScreenHeight - tableH - tableH;
//        
//    };
//    
//    self.searchView.end = ^ {
//        vc.tableView.height = tableH;
//        vc.tableView.y = kScreenHeight - tableH;
//    };

    
    [self.view addSubview:self.searchView];
    
    
    
     _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
//    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
//    _mapView setCenterCoordinate:<#(CLLocationCoordinate2D)#>
    
    
    
}

- (void)confirm {
    // 传值
    if (!self.latitude || !self.longitude) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请从下列地址中选择" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        if (!self.searchView.submitAddress.text.length) {// 用户未填写详细信息
            [self.delegate pushAddress:[NSString stringWithFormat:@"%@%@",self.searchView.mainAddress.text, self.submitAddress] latitude:self.latitude longitude:self.longitude clickedTextFiled:self.clickedTF];
        } else {
            [self.delegate pushAddress:[NSString stringWithFormat:@"%@%@",self.searchView.mainAddress.text, self.searchView.submitAddress.text] latitude:self.latitude longitude:self.longitude clickedTextFiled:self.clickedTF];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchWithStr:(NSString *)str {
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = str;
    tipsRequest.city = @"台州市";
    
    //发起输入提示搜索
    [self.search AMapInputTipsSearch: tipsRequest];
}

- (void)edit {
    self.tableView.height = tableH * 2;
    self.tableView.y = kScreenHeight - tableH - tableH;
}

- (void)end {
    self.tableView.height = tableH;
    self.tableView.y = kScreenHeight - tableH;
}


//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
//        self.tableView.hidden = YES;
        return;
    }
//    self.tableView.hidden = NO;
    [self.dataArray removeAllObjects];
    [self.poiArray removeAllObjects];
    for (AMapTip *p in response.tips) {
        NSLog(@"%@",p);
        if (![p.address isEqualToString:@""]) {
            [self.dataArray addObject:p];
        }
    }
    [self.tableView reloadData];
    
   
}

/**
 * @brief 地图区域改变完成后会调用此接口
 * @param mapview 地图View
 * @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // 逆地理编码对象
    
    AMapReGeocodeSearchRequest *reGeo = [[AMapReGeocodeSearchRequest alloc] init];
    reGeo.location = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    reGeo.radius = 200;
    reGeo.requireExtension = YES;
    //发起逆向地理编码
    [_search AMapReGoecodeSearch:reGeo];
    
}

/**
 *  逆地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSLog(@"%@",response);
    
    NSLog(@"%@",response.regeocode.formattedAddress);
    
//    self.searchView.mainAddress.text = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.city, response.regeocode.addressComponent.district];
//    self.searchView.submitAddress.text = [NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building, response.regeocode.addressComponent.streetNumber.street, response.regeocode.addressComponent.streetNumber.number];
//    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building, response.regeocode.addressComponent.streetNumber.street, response.regeocode.addressComponent.streetNumber.number]);
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *requestPOI = [[AMapPOIAroundSearchRequest alloc] init];
    requestPOI.location = [AMapGeoPoint locationWithLatitude:request.location.latitude longitude:request.location.longitude];
//    requestPOI.keywords = @"方恒";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    requestPOI.types = @"地名地址信息|商务住宅|公司企业|购物服务|生活服务|道路附属设施|汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公共设施";
    requestPOI.sortrule = 0;// 距离排序
    requestPOI.radius = 50;
    requestPOI.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: requestPOI];
    
    
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self.dataArray removeAllObjects];
    [self.poiArray removeAllObjects];
    for (AMapPOI *poi in response.pois) {
        NSLog(@"%@",poi);
        [self.poiArray addObject:poi];
    }
    [self.tableView reloadData];
    
}


#pragma mark -----TableView的Delegate和DataSource-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count ? self.dataArray.count : self.poiArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"reuse";
    
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil] lastObject];
    }
    if (_dataArray.count) {
        [cell setDataWithModel:self.dataArray[indexPath.row]];
        cell.current.hidden = YES;
    } else {
        [cell setDataWithPOI:self.poiArray[indexPath.row]];
        if (indexPath.row) {
            cell.current.hidden = YES;
        } else {
            cell.current.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count) {
        AMapTip *tip = self.dataArray[indexPath.row];
        self.searchView.mainAddress.text = [NSString stringWithFormat:@"%@附近",tip.name];
        self.mainAddress = self.searchView.mainAddress.text;
        self.submitAddress = tip.address;
//        self.searchView.submitAddress.text = tip.address;
        self.latitude = [NSString stringWithFormat:@"%f",tip.location.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",tip.location.longitude];
    } else {
        AMapPOI *poi = self.poiArray[indexPath.row];
        self.searchView.mainAddress.text = [NSString stringWithFormat:@"%@附近",poi.name];
//        self.searchView.submitAddress.text = poi.address;
        self.mainAddress = self.searchView.mainAddress.text;
        self.submitAddress = poi.address;
        self.latitude = [NSString stringWithFormat:@"%f",poi.location.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",poi.location.longitude];
    }
    
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

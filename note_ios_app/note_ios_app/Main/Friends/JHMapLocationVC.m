//
//  JHMapLocationVC.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/23.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHMapLocationVC.h"
#import "JHMapAnnotation.h"
#import "JH_CalculateUtil.h"
@interface JHMapLocationVC ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labAddressName;
@property (weak, nonatomic) IBOutlet UILabel *labAddressDetail;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *annotationView;

@end

@implementation JHMapLocationVC
{
    CLLocationManager *_locationManager;//定位管理
    CLGeocoder *_geocoder;//地理编码
    //当前地图中心点和名称
    double _latitude_center;
    double _longitude_center;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setNavigationItem];
    [self initMap];
}

/**
 设置导航栏按钮
 */
-(void)_setNavigationItem{
    if (self.userLocation) {
        self.title = @"路线";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(_cancelAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导航" style:0 target:self action:@selector(_navigationAction)];
        return;
    }
    self.title = @"位置";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(_cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:0 target:self action:@selector(_sendAction)];
}

/**
 点击导航
 */
-(void)_navigationAction{
    [self _openNavigationByLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude onlyRoute:NO];
}
/**
 点击取消
 */
-(void)_cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

/**
 点击发送
 */
-(void)_sendAction{
    _locationBlock(_latitude_center,_longitude_center);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 初始化地图定位
-(void)initMap{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    //地理编码
    _geocoder=[[CLGeocoder alloc]init];
    //地图视图
    _mapView.delegate = self;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    //当为点击进入的则展示好友坐标点
    if (self.userLocation) {
        self.annotationView.hidden = YES;
        [self _addAnnotationByLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
        //路径规划
        [self _openNavigationByLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude onlyRoute:YES];
    }
    
}
#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    //        NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //根据坐标获取地址
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if (self.userLocation) {
        //计算中心位置
        double centerLatitude = (coordinate.latitude + _userLocation.coordinate.latitude)/2;
        double centerLongitude = (coordinate.longitude + _userLocation.coordinate.longitude)/2;
        //计算距离
        double distance =  [JH_CalculateUtil getDistanceByLatitude1:coordinate.latitude longitude1:coordinate.longitude latitude2:_userLocation.coordinate.latitude longitude2:_userLocation.coordinate.longitude];
        //第一个参数指定目标区域的中心点，第二个参数是目标区域的南北跨度，单位为米。第三个参数为目标区域东西跨度，单位为米。后2个参数的调整会影响地图的缩放
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(centerLatitude, centerLongitude), distance ,distance);
        //重新设置地图视图的显示区域
        [_mapView setRegion:viewRegion animated:YES];
    }
    
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}
#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark= [placemarks firstObject];
        _labAddressName.text = placemark.name;
        _labAddressDetail.text = [placemark.addressDictionary[@"FormattedAddressLines"]firstObject ];
        
    }];
}
#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //        MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //        MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //        [_mapView setRegion:region animated:true];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    return nil;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"中心点：%f,%f",_mapView.region.center.latitude,_mapView.region.center.longitude);
//    NSLog(@"缩放比例：%f,%f", _mapView.region.span.latitudeDelta,_mapView.region.span.longitudeDelta);
    if (self.userLocation) {
        [self getAddressByLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
        return;
    }
    _latitude_center = mapView.region.center.latitude;
    _longitude_center = mapView.region.center.longitude;
    //获取中心点位置
    [self getAddressByLatitude:_mapView.region.center.latitude longitude:_mapView.region.center.longitude];
}
#pragma mark - 选中图标
//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    
//}

#pragma mark - 插入导航点
-(void)_addAnnotationByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //获取我的位置
//    JHMapAnnotation *annotation2 = [[JHMapAnnotation alloc]init];
//    annotation2.title=@"开始位置";
//    annotation2.subtitle=@"点击右上角可以导航哦";
//    annotation2.coordinate=_mapView.userLocation.location.coordinate;
//    [_mapView addAnnotation:annotation2];
    //对方位置
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(latitude, longitude);
    JHMapAnnotation *annotation1=[[JHMapAnnotation alloc]init];
    annotation1.title=@"目标位置";
    annotation1.subtitle=@"点击右上角可以导航哦";
    annotation1.coordinate=location1;
    //添加图标
    [_mapView addAnnotation:annotation1];
    
}

//线路的绘制
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer;
    renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = BaseColor;
    
    return renderer;
}
#pragma mark - 开启导航功能

/**
 路径规划和导航公用方法

 @param latitude 纬度
 @param longitude 经度
 @param onlyRoute yes则为路径规划
 */
-(void)_openNavigationByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude onlyRoute:(BOOL)onlyRoute{
    //隐藏中间的那个图标
    self.annotationView.hidden = YES;
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark= [placemarks firstObject];
        MKPlacemark *mkPlaceMark = [[MKPlacemark alloc] initWithPlacemark:placemark];
        MKMapItem *item1 = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *item2 = [[MKMapItem alloc] initWithPlacemark:mkPlaceMark];
        
        if (onlyRoute) {
            //开启路劲规划
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
            request.source = item1;
            request.destination = item2;
            request.requestsAlternateRoutes = YES;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
            [directions calculateDirectionsWithCompletionHandler:
             ^(MKDirectionsResponse *response, NSError *error) {
                 if (error) {
                     NSLog(@"error:%@", error);
                 }
                 else {
                     MKRoute *route = response.routes[0];
                     [self.mapView addOverlay:route.polyline];
                 }
             }];
        }else{
            //开启导航
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
            [MKMapItem openMapsWithItems:@[item1,item2] launchOptions:options];
        }
        
    }];
    
}

@end

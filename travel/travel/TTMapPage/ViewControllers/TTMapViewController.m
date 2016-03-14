//
//  TTMapViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import "TTMapViewController.h"
#import "TTMapCalloutView.h"
#import "TTCalloutAnnotationView.h"
#import "TTMethodViewController.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

static NSString * const reuseIdetifier = @"pin";
@interface TTMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, setCalloutViewDelegate, CLLocationManagerDelegate, mapCalloutViewBtnDelegate>

/** MapView */
@property (nonatomic, strong) MAMapView *mapView;

/** 搜索 */
@property (nonatomic, strong) AMapSearchAPI *search;

/** 定位manager */
@property (nonatomic, strong)CLLocationManager *manager;

/** 经度 */
@property (nonatomic, assign) double coordinateLati;

/** 纬度 */
@property (nonatomic, assign) double coordinateLongi;

@end

@implementation TTMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 由于有在地图上面添加button，因此需要先加载地图然后加button，不然button不显示
    [self setupMap];
    [self setupView];

}

#pragma mark 加载view
- (void)setupView
{
    self.navigationItem.title = @"旅行地图";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ButtonBack2_Normal"] forState:UIControlStateNormal];
    backBtn.alpha = 0.7;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
}

#pragma mark 加载地图
- (void)setupMap
{
    
    // 定位
    self.mapView.showsUserLocation = YES;
    self.manager = [CLLocationManager new];
    [self.manager requestAlwaysAuthorization];
    [self.manager requestWhenInUseAuthorization];
    
    [self.manager startUpdatingLocation];
    self.manager.delegate = self;
    
    // 初始化MAPVIEW
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate = self;
    
//    TTLog(@"minlevel%f", self.mapView.minZoomLevel);
//    TTLog(@"maxlevel%f", self.mapView.maxZoomLevel);
    
    [self.mapView setZoomLevel:17.f animated:YES];
    
    [self.view addSubview:self.mapView];
    
    // 搜索
    self.search = [[AMapSearchAPI alloc]init];
    
    self.search.delegate = self;
    
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:self.destinationLati longitude:self.destinationLongi];
    // 查询半径
    regeo.radius = 10000;
    // 返回拓展信息
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

#pragma mark 地图上返回按钮
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    self.coordinateLati = location.coordinate.latitude;
    self.coordinateLongi = location.coordinate.longitude;
    if (self.destinationLati == 0.0 && self.destinationLongi == 0.0)
    {
        self.destinationLati = self.coordinateLati;
        self.destinationLongi = self.coordinateLongi;
    }
}

#pragma mark 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        CLLocation *location = [[CLLocation alloc]initWithLatitude:self.destinationLati longitude:self.destinationLongi];

        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
            pointAnnotation.title = [placemarks firstObject].locality;
            pointAnnotation.coordinate = location.coordinate;
            [self.mapView addAnnotation:pointAnnotation];
            
            // 显示所有标注的地方，如果只有一个则当前标注位置为地图中心点
            [self.mapView showAnnotations:@[pointAnnotation] animated:YES];
        }];
    }
}

#pragma mark 返回标注view
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
         TTCalloutAnnotationView *annotationView = (TTCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdetifier];
        if (annotationView == nil)
        {
            annotationView = [[TTCalloutAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdetifier];
        }
//        if (self.icon_type == 0)
//        {
//            annotationView.image = [UIImage imageNamed:@"map_pin_red"];
//        } else if (self.icon_type == 1)
//        {
//            annotationView.image = [UIImage imageNamed:@"map_pin"];
//        } else if (self.icon_type == 2)
//        {
//            annotationView.image = [UIImage imageNamed:@"map_pin_selected"];
//        }
        annotationView.image = [UIImage imageNamed:@"map_pin"];

        annotationView.cvDelegate = self;
        
        return annotationView;
    } else {
        return nil;
    }
}

#pragma mark - setCalloutViewDelegate
#pragma mark 设置气泡的topic，tip和image
- (NSString *)setTopicText
{
    return self.topic;
}

- (NSString *)setTipText
{
    return self.visit_tip;
}

- (UIImage *)setImage
{
    UIImage *image = nil;
    if ([self.icon_type isEqualToString:@"0"]) {
        image = [UIImage imageNamed:@"icon_plan_cell_restaurant"];
    } else if ([self.icon_type isEqualToString:@"1"]) {
        image = [UIImage imageNamed:@"icon_plan_cell_hotel"];
    } else if ([self.icon_type isEqualToString:@"2"]) {
        image = [UIImage imageNamed:@"icon_plan_cell_attraction"];
    } else {
        image = [UIImage imageNamed:@"CNY"];
    }
    return image;
}

#pragma mark - mapCalloutViewBtnDelegate
#pragma mark 点击导航按钮，跳到苹果地图导航
- (void)useAppleMapNav
{
    CLLocationCoordinate2D desCoordinate = CLLocationCoordinate2DMake(self.destinationLati, self.destinationLongi);

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark: placemark];
    MKMapItem *currentItem = [MKMapItem mapItemForCurrentLocation];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    options[MKLaunchOptionsMapTypeKey] = @(MKMapTypeHybrid);
    options[MKLaunchOptionsShowsTrafficKey] = @(YES);
    
    [MKMapItem openMapsWithItems: @[currentItem, item] launchOptions: options];
}
#pragma mark 查看攻略按钮
- (void)goMethodVC
{
    if (![self.mID isEqual:[NSNull null]]) {
        if (![self.mID isEqual:@""]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

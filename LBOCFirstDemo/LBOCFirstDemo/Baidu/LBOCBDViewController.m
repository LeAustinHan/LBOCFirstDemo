//
//  LBOCBDViewController.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/3.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCBDViewController.h"


@interface LBOCBDViewController ()

@end

@implementation LBOCBDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化定位SDK
    [self.mainViewModel startMapManager];
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    
    __block BMKMapView *blockMapView = self.mapView;
    [self.mainViewModel registerUploadLocationInfoBlock:^(BMKUserLocation * _Nullable userLocation) {
        [blockMapView updateLocationData:userLocation];
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 20, 40, 40);
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *buttonNavWalk= [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavWalk.frame = CGRectMake(90,20, 80, 40);
    [buttonNavWalk setTitle:@"步行路线" forState:UIControlStateNormal];
    [buttonNavWalk setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buttonNavWalk.backgroundColor = [UIColor whiteColor];
    [buttonNavWalk addTarget:self action:@selector(buttonClickNavWalk:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavWalk];
    
    UIButton *buttonNavBus= [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavBus.frame = CGRectMake(90*2,20, 80, 40);
    [buttonNavBus setTitle:@"公交路线" forState:UIControlStateNormal];
    [buttonNavBus setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buttonNavBus.backgroundColor = [UIColor whiteColor];
    [buttonNavBus addTarget:self action:@selector(buttonClickNavBus:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavBus];
    
    UIButton *buttonNavCar = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavCar.frame = CGRectMake(90*3, 20, 80, 40);
    [buttonNavCar setTitle:@"驾驶路线" forState:UIControlStateNormal];
    [buttonNavCar setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buttonNavCar.backgroundColor = [UIColor whiteColor];
    [buttonNavCar addTarget:self action:@selector(buttonClickNavCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavCar];
    
    UITextView *navTextView = [[UITextView alloc] init];
    navTextView.frame = CGRectMake(0, KScreenHeight*2/3, KScreenWidth, KScreenHeight/3);
    navTextView.backgroundColor = [UIColor whiteColor];
    navTextView.textColor = [UIColor orangeColor];
    [self.view addSubview:navTextView];
    navTextView.hidden = YES;
    self.navTextView = navTextView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
//    [_locService stopUserLocationService];// 停止定位
    _mapView.showsUserLocation = NO;
}

- (void)buttonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)buttonClickNavWalk:(id)sender{
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    [self onClickWalkSearchCurrentMapAnnotation:self.mainViewModel.userLocation.location.coordinate toTargetLocationInfo:targetLocation.coordinate];
}

- (void)buttonClickNavBus:(id)sender{
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    [self onClickBusSearchCurrentMapAnnotation:self.mainViewModel.userLocation.location.coordinate toTargetLocationInfo:targetLocation.coordinate];
}

- (void)buttonClickNavCar:(id)sender{
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    [self onClickCarSearchCurrentMapAnnotation:self.mainViewModel.userLocation.location.coordinate toTargetLocationInfo:targetLocation.coordinate];
}

// 步行路线规划
- (void)onClickWalkSearchCurrentMapAnnotation:(CLLocationCoordinate2D )currentCoordinate2D toTargetLocationInfo:(CLLocationCoordinate2D )targetCoordinate2D {
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
    start.pt = currentCoordinate2D;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.pt = targetCoordinate2D;
    BMKWalkingRoutePlanOption *walkRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkRouteSearchOption.from = start;
    walkRouteSearchOption.to = end;
    BOOL flag = [self.routesearch walkingSearch:walkRouteSearchOption];
    if(flag){
        NSLog(@"walk检索发送成功");
    }
    else{
        NSLog(@"walk检索发送失败");
    }
}

// 公交路线规划
- (void)onClickBusSearchCurrentMapAnnotation:(CLLocationCoordinate2D )currentCoordinate2D toTargetLocationInfo:(CLLocationCoordinate2D )targetCoordinate2D {
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
//    start.name = currentMapAnnotation.title;
    start.pt = currentCoordinate2D;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
//    end.name = targetMapAnnotation.title;
    end.pt = targetCoordinate2D;
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    //transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [self.routesearch transitSearch:transitRouteSearchOption];
    if(flag){
        NSLog(@"bus检索发送成功");
    }
    else{
        NSLog(@"bus检索发送失败");
    }
}

// 驾车路线规划
- (void)onClickCarSearchCurrentMapAnnotation:(CLLocationCoordinate2D )currentCoordinate2D toTargetLocationInfo:(CLLocationCoordinate2D )targetCoordinate2D {
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
    //start.name = @"北四环东路辅路";
    start.pt = currentCoordinate2D;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    //end.name = @"黄寺大街";
    end.pt = targetCoordinate2D;
    BMKDrivingRoutePlanOption *transitRouteSearchOption = [[BMKDrivingRoutePlanOption alloc] init];
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [self.routesearch drivingSearch:transitRouteSearchOption];
    if(flag) {
        NSLog(@"car检索发送成功");
    } else {
        NSLog(@"car检索发送失败");
    }
}

#pragma mark - Lazy loading
- (LBOCBDViewControllerVM *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[LBOCBDViewControllerVM alloc] init];
    }
    return _mainViewModel;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _mapView.backgroundColor = [UIColor lightGrayColor];
        //设置mapView的代理
        _mapView.delegate = self;
        //显示定位图层
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

- (BMKRouteSearch *)routesearch {
    if (!_routesearch) {
    //初始化BMKLocationManager类的实例
    _routesearch = [[BMKRouteSearch alloc] init];
    _routesearch.delegate = self;
    }
    return _routesearch;
}

@end

//
//  LBOCBDViewController.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/3.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCBDViewController.h"

#import <BMKLocationkit/BMKLocationComponent.h>
#import "QTXRouteAnnotation.h"
#import "LBOCHappyMapAnnotation.h"
#import "LBOCHappyLocationManager.h"
#import "UIImage+Rotate.h"


@interface LBOCBDViewController ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKRouteSearchDelegate,BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类

@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@property (nonatomic, strong) BMKRouteSearch *routesearch;
@property (nonatomic, copy) NSString *address;


@property (nonatomic, strong) UITextView *navTextView;

@end

@implementation LBOCBDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化定位SDK
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"3cbe52cb0365801546ded14569447d6d" authDelegate:self];
    //要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:@"3cbe52cb0365801546ded14569447d6d" generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }
    
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    //显示定位图层
    _mapView.showsUserLocation = YES;
    [self createMapView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 5, 60, 60);
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *buttonNavWalk= [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavWalk.frame = CGRectMake(90, 5, 80, 60);
    [buttonNavWalk setTitle:@"步行路线" forState:UIControlStateNormal];
    [buttonNavWalk setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonNavWalk.backgroundColor = [UIColor lightGrayColor];
    [buttonNavWalk addTarget:self action:@selector(buttonClickNavWalk:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavWalk];
    
    UIButton *buttonNavBus= [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavBus.frame = CGRectMake(90+90, 5, 80, 60);
    [buttonNavBus setTitle:@"公交路线" forState:UIControlStateNormal];
    [buttonNavBus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonNavBus.backgroundColor = [UIColor lightGrayColor];
    [buttonNavBus addTarget:self action:@selector(buttonClickNavBus:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavBus];
    
    UIButton *buttonNavCar = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNavCar.frame = CGRectMake(90+90+90, 5, 80, 60);
    [buttonNavCar setTitle:@"驾驶路线" forState:UIControlStateNormal];
    [buttonNavCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonNavCar.backgroundColor = [UIColor lightGrayColor];
    [buttonNavCar addTarget:self action:@selector(buttonClickNavCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNavCar];
    
    UITextView *navTextView = [[UITextView alloc] init];
    navTextView.frame = CGRectMake(0, KScreenHeight*2/3, KScreenWidth, KScreenHeight/3);
    navTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navTextView];
    self.navTextView = navTextView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    
    // 停止定位
//    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

- (void)createMapView {
    //将mapView添加到当前视图中
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:self.mapView];
    self.mapView.backgroundColor = [UIColor lightGrayColor];
    //设置mapView的代理
    _mapView.delegate = self;
}

- (void)buttonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)buttonClickNavWalk:(id)sender{
    LBOCHappyMapAnnotation *cMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    cMapAnnotation.coordinate = [[LBOCHappyLocationManager sharedInstance] getLocation].coordinate;
    cMapAnnotation.title = [[LBOCHappyLocationManager sharedInstance] getLocationAddressInfo];
    
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    LBOCHappyMapAnnotation *tMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    tMapAnnotation.coordinate = targetLocation.coordinate;
    tMapAnnotation.title = @"北京市朝阳区北四环东路69号";
    
    [self onClickWalkSearchCurrentMapAnnotation:cMapAnnotation toTargetLocationInfo:tMapAnnotation];
}

- (void)buttonClickNavBus:(id)sender{
    LBOCHappyMapAnnotation *cMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    cMapAnnotation.coordinate = [[LBOCHappyLocationManager sharedInstance] getLocation].coordinate;
    cMapAnnotation.title = [[LBOCHappyLocationManager sharedInstance] getLocationAddressInfo];
    
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    LBOCHappyMapAnnotation *tMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    tMapAnnotation.coordinate = targetLocation.coordinate;
    tMapAnnotation.title = @"北京市朝阳区北四环东路69号";
    
    [self onClickBusSearchCurrentMapAnnotation:cMapAnnotation toTargetLocationInfo:tMapAnnotation];
}

- (void)buttonClickNavCar:(id)sender{
    LBOCHappyMapAnnotation *cMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    cMapAnnotation.coordinate = [[LBOCHappyLocationManager sharedInstance] getLocation].coordinate;
    cMapAnnotation.title = [[LBOCHappyLocationManager sharedInstance] getLocationAddressInfo];
    
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.995831 longitude:116.44098];//注意，先是纬度，后面是经度
    LBOCHappyMapAnnotation *tMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    tMapAnnotation.coordinate = targetLocation.coordinate;
    tMapAnnotation.title = @"北京市朝阳区北四环东路69号";
    
    [self onClickCarSearchCurrentMapAnnotation:cMapAnnotation toTargetLocationInfo:tMapAnnotation];
}

/*
#pragma mark - Navigation
 */


// 步行路线规划
- (void)onClickWalkSearchCurrentMapAnnotation:(LBOCHappyMapAnnotation *)currentMapAnnotation toTargetLocationInfo:(LBOCHappyMapAnnotation *)targetMapAnnotation {

    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
    start.name = currentMapAnnotation.title;
    start.pt = currentMapAnnotation.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = targetMapAnnotation.title;
    end.pt = targetMapAnnotation.coordinate;
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [self.routesearch walkingSearch:transitRouteSearchOption];
    if(flag){
        NSLog(@"bus检索发送成功");
    }
    else{
        NSLog(@"bus检索发送失败");
    }
}



// 公交路线规划
- (void)onClickBusSearchCurrentMapAnnotation:(LBOCHappyMapAnnotation *)currentMapAnnotation toTargetLocationInfo:(LBOCHappyMapAnnotation *)targetMapAnnotation {

    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
    start.name = currentMapAnnotation.title;
    start.pt = currentMapAnnotation.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = targetMapAnnotation.title;
    end.pt = targetMapAnnotation.coordinate;
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"北京市";
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
- (void)onClickCarSearchCurrentMapAnnotation:(LBOCHappyMapAnnotation *)currentMapAnnotation toTargetLocationInfo:(LBOCHappyMapAnnotation *)targetMapAnnotation {
    
    // 起始地址
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
    start.name = @"北四环东路辅路";
    start.pt = currentMapAnnotation.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = @"黄寺大街";
    end.pt = targetMapAnnotation.coordinate;
    BMKDrivingRoutePlanOption *transitRouteSearchOption = [[BMKDrivingRoutePlanOption alloc] init];
    //transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    
    
    BOOL flag = [self.routesearch drivingSearch:transitRouteSearchOption];
    if(flag) {
        NSLog(@"car检索发送成功");
    } else {
        NSLog(@"car检索发送失败");
    }
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QTXRouteAnnotation class]]) {
        return [self getQTXRouteAnnotationView:view viewForAnnotation:(QTXRouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView*)getQTXRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(QTXRouteAnnotation*)QTXRouteAnnotation
{
    NSString *tempText = self.navTextView.text;
    self.navTextView.text = [NSString stringWithFormat:@"%@\n%@",tempText,QTXRouteAnnotation.title    ];
    
    BMKAnnotationView* view = nil;
    switch (QTXRouteAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"start_node"];
                NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
                NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
                NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_nav_start"] ofType:@"png"];
                view.image = [UIImage imageWithContentsOfFile:img_path];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = QTXRouteAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"end_node"];
                
                NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
                NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
                NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_nav_end"] ofType:@"png"];
                view.image = [UIImage imageWithContentsOfFile:img_path];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = QTXRouteAnnotation;
        }
            break;
        case 2:
        {
             view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
             if (view == nil) {
                 
                 view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"bus_node"];
                 NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
                 NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
                 NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_nav_bus"] ofType:@"png"];
                 view.image = [UIImage imageWithContentsOfFile:img_path];
                 view.canShowCallout = TRUE;
        }
                view.annotation = QTXRouteAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                
                view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"rail_node"];
                NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
                NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
                NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_nav_rail"] ofType:@"png"];
                view.image = [UIImage imageWithContentsOfFile:img_path];
                view.canShowCallout = TRUE;
             }
            view.annotation = QTXRouteAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = true;
                } else {
                    [view setNeedsDisplay];
                }
            view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"rail_node"];
            NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_direction"] ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:img_path];
            view.image = [image imageRotatedByDegrees:QTXRouteAnnotation.degree];
            view.annotation = QTXRouteAnnotation;
            }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:QTXRouteAnnotation reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"mapapi" ofType :@"bundle"];
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            NSString *img_path = [bundle pathForResource:[NSString stringWithFormat:@"images/%@",@"icon_nav_waypoint"] ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:img_path];
            view.image = [image imageRotatedByDegrees:QTXRouteAnnotation.degree];
        }
            break;

        default:
            break;
    }
    return view;
}

#pragma mark - BMKLocationManagerDelegate
/**
 @brief 当定位发生错误时，会调用代理的此方法
 @param manager 定位 BMKLocationManager 类
 @param error 返回的错误，参考 CLError
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

/**
 @brief 该方法为BMKLocationManager提供设备朝向的回调方法
 @param manager 提供该定位结果的BMKLocationManager类的实例
 @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    NSLog(@"定位成功，纬度 == %f，经度 == %f",location.location.coordinate.latitude,location.location.coordinate.longitude);
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = malloc(sizeof(CLLocationCoordinate2D) * planPointCounts);
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        //delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else {
        //[MBProgressHUD showError:@"位置暂时不确定，无法进行规划路线"];
    }
}


- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint *temppoints = malloc(sizeof(CLLocationCoordinate2D) * planPointCounts);
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        [self mapViewFitPolyLine:polyLine];
    } else {
        //[MBProgressHUD showError:@"位置暂时不确定，无法进行规划路线"];
    }
}


- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            QTXRouteAnnotation* item = [[QTXRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint *temppoints = malloc(sizeof(CLLocationCoordinate2D) * planPointCounts);
        
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay  delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else {
        //[MBProgressHUD showError:@"位置暂时不确定，无法进行规划路线"];
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    (void)(ltX = pt.x), ltY = pt.y;
    (void)(rbX = pt.x), rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark - Lazy loading

- (BMKRouteSearch *)routesearch {
    if (!_routesearch) {
    //初始化BMKLocationManager类的实例
    _routesearch = [[BMKRouteSearch alloc] init];
    _routesearch.delegate = self;
    }
    return _routesearch;
}



- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

@end

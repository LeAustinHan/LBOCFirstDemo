//
//  ViewController.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/11/28.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCViewController.h"

#import "LBOCLocationInfoView.h"
#import <MapKit/MapKit.h>
//#import "EasyGPSLocation.h"
#import "LBOCMapLocationViewController.h"

@interface LBOCViewController ()

@property (nonatomic,strong) UILabel *titleLabel;/**< 注释 标题label*/

@property (nonatomic,strong) CLLocation * currentLocation;

@property (nonatomic,strong) CLLocation * targetLocation;

@end

@implementation LBOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"定位Demo";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);//设置绝对高度
        make.width.mas_equalTo(200);
    }];
    
    UIButton *shareLocationButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:shareLocationButon];
    [shareLocationButon setTitle: @"调起地图App" forState:UIControlStateNormal];
    shareLocationButon.backgroundColor = [UIColor cyanColor];
    [shareLocationButon addTarget:self action:@selector(shareLocationToMapApp) forControlEvents:UIControlEventTouchUpInside];
    [shareLocationButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(100);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);//设置绝对高度
        make.width.mas_equalTo(200);
    }];
    
    UIButton *shareLocationBaiDuButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:shareLocationBaiDuButon];
    [shareLocationBaiDuButon setTitle: @"调起百度地图App" forState:UIControlStateNormal];
    shareLocationBaiDuButon.backgroundColor = [UIColor greenColor];
    [shareLocationBaiDuButon addTarget:self action:@selector(shareLocationToBaiDuMapApp) forControlEvents:UIControlEventTouchUpInside];
    [shareLocationBaiDuButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareLocationButon).offset(100);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);//设置绝对高度
        make.width.mas_equalTo(200);
    }];
    
    LBOCLocationInfoView *locInfoView = [[LBOCLocationInfoView alloc] init];
    locInfoView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:locInfoView];
    
    [locInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareLocationBaiDuButon).offset(100);
        make.centerX.equalTo(shareLocationButon);
        make.height.mas_equalTo(300);//设置绝对高度
        make.width.mas_equalTo(400);
    }];
    
    [self locate];
}

- (void)shareLocationToBaiDuMapApp{//:(CLLocation *)currentLocation withTarget:(CLLocation *)targetLocation{//打开系统地图App
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude,self.targetLocation.coordinate.latitude, self.targetLocation.coordinate.longitude, @"目的地名称"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: @"baidumap://"]]){
        if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]] == NO){
            
        }
     
        } else {
     
            //[AutoAlertView ShowMessage:@"没有安装百度地图"];
    }

}

- (void)shareLocationToMapApp{//:(CLLocation *)currentLocation withTarget:(CLLocation *)targetLocation{//打开系统地图App
    // 起点
    MKMapItem *currentLocationItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:
                                                                           self.currentLocation.coordinate addressDictionary: nil]];
    currentLocationItem.name = @"我的位置";

    // 目的地的位置
    MKMapItem *toLocationItem = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate:
                                                                       self.targetLocation.coordinate addressDictionary:nil]];
    toLocationItem.name = @"目的地的名字";

    NSArray *items = [NSArray arrayWithObjects:currentLocationItem, toLocationItem, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                               MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard],
                               MKLaunchOptionsShowsTrafficKey: @YES };
     
    //打开苹果地图应用，并呈现指定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

- (void)locate {
    if ([CLLocationManager locationServicesEnabled]) {//监测权限设置
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;//设置代理
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置精度
        self.locationManager.distanceFilter = 1000.0f;//距离过滤
        [self.locationManager requestAlwaysAuthorization];//位置权限申请
        [self.locationManager startUpdatingLocation];//开始定位
    }
}
#pragma mark location代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:setingsURL];
    }];
    [alert addAction:cancel];
    [alert addAction:queren];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];//停止定位
//地理反编码
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.996 longitude:116.439];//注意，先是纬度，后面是京都
    self.targetLocation = targetLocation;
    
    CLLocation *currentLocation = [locations lastObject];//坐标信息
    self.currentLocation = currentLocation;
/*
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
//当系统设置为其他语言时，可利用此方法获得中文地理名称
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil]forKey:@"AppleLanguages"];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *city = placeMark.locality;
            if (!city) {
                self.currentCity = @"⟳定位获取失败,点击重试";
            } else {
                self.currentCity = placeMark.locality ;//获取当前城市
             
            }
            if (self.currentCity.length) {
                self.titleLabel.text = self.currentCity;
            }
           // self.titleLabel.text = placeMark.addressDictionary;

        } else if (error == nil && placemarks.count == 0 ) {
        } else if (error) {
            self.currentCity = @"⟳定位获取失败,点击重试";
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
    */
}

#pragma mark === about map ===
- (void)clickToMapVC{
    //确定用户的位置服务是否启用,位置服务在设置中是否被禁用
    BOOL enable  = [CLLocationManager locationServicesEnabled];
    NSInteger status = [CLLocationManager authorizationStatus];
    if(  !enable || status< 2){
        //尚未授权位置权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            //系统位置授权弹窗
            _locationManager =[[CLLocationManager alloc]init];
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
    }else{
        if (status == kCLAuthorizationStatusDenied) {
            //拒绝使用位置
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"地点功能需要开启位置授权" delegate:self cancelButtonTitle:@"暂不设置" otherButtonTitles:@"现在去设置", nil];
            [alterView show];
        }else{
            //允许使用位置#import "LBOCMapLocationViewController.h"
            LBOCMapLocationViewController *mapVC =[[LBOCMapLocationViewController alloc] init];
//            mapVC.fromComment =YES;
//            mapVC.delegate =self;
//            if ([self.delegate respondsToSelector:@selector(presentVC:)]) {
//                [self.delegate presentVC:mapVC];
//            }
        }
    }
}



#pragma mark === lazy loading ===
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}


@end

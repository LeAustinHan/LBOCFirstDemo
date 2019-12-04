//
//  ViewController.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/11/28.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCViewController.h"

#import <MapKit/MapKit.h>
#import "LBOCMapLocationViewController.h"

#import "LBOCHappyLocationManager.h"
#import "LBOCHappyMapManager.h"
#import "LBOCHanppyMapViewController.h"
#import "LBOCBDViewController.h"

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
        make.width.mas_equalTo(300);
    }];
    
    UIButton *starLocationButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:starLocationButon];
    [starLocationButon setTitle: @"开始定位" forState:UIControlStateNormal];
    starLocationButon.backgroundColor = [UIColor orangeColor];
    [starLocationButon addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    [starLocationButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(80);
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
        make.top.equalTo(starLocationButon).offset(80);
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
        make.top.equalTo(shareLocationButon).offset(80);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);//设置绝对高度
        make.width.mas_equalTo(200);
    }];

    [[LBOCHappyLocationManager sharedInstance] registerGPSLocationResultBlock:^(BOOL success) {
        if(success){
            self.titleLabel.text = [[LBOCHappyLocationManager sharedInstance] getLocationAddressInfo];
        }else{
            NSLog(@"权限错误");
        }
    }];
}

- (void)startLocation{
    [[LBOCHappyLocationManager sharedInstance] startLocation];
}

- (void)shareLocationToBaiDuMapApp{//打开系统地图App
//    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.996 longitude:116.439];//注意，先是纬度，后面是京都
//    [[LBOCHappyMapManager sharedInstance] shareToTestMapAppWithTarget:targetLocation andTargetLocationInfo:@"目的地"];
    
    
    LBOCBDViewController *mapVCL = [[LBOCBDViewController
                                      alloc] init];
    [self presentViewController:mapVCL animated:YES completion:^{
        
    }];

}

- (void)shareLocationToMapApp{//打开系统地图App
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:39.996 longitude:116.439];//注意，先是纬度，后面是京都
//    [[LBOCHappyMapManager sharedInstance] shareLocationToMapAppWithTarget:targetLocation andTargetLocationInfo:@"目的地"];
    
    [[LBOCHappyLocationManager sharedInstance] startLocation];
    
    LBOCHanppyMapViewController *mapVCL = [[LBOCHanppyMapViewController
                                      alloc] init];
    [self presentViewController:mapVCL animated:YES completion:^{
        
    }];
    LBOCHappyMapAnnotation *cMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    cMapAnnotation.coordinate = [[LBOCHappyLocationManager sharedInstance] getLocation].coordinate;
    cMapAnnotation.title = [[LBOCHappyLocationManager sharedInstance] getLocationAddressInfo];
    
    LBOCHappyMapAnnotation *tMapAnnotation = [[LBOCHappyMapAnnotation alloc] init];
    tMapAnnotation.coordinate = targetLocation.coordinate;
    tMapAnnotation.title = @"北京市朝阳区北四环东路辅路远洋未来广场";
    
    [mapVCL guideCurrentMapAnnotation:cMapAnnotation toTargetLocationInfo:tMapAnnotation];
}


#pragma mark location代理
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication]openURL:setingsURL];
//    }];
//    [alert addAction:cancel];
//    [alert addAction:queren];
//    [self.navigationController presentViewController:alert animated:YES completion:nil];
//}

#pragma mark === lazy loading ===
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}


@end

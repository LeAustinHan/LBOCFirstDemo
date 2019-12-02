//
//  LBOCLocationInfoViewModel.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/2.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCLocationInfoViewModel.h"

@implementation LBOCLocationInfoViewModel

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
//#pragma mark location代理
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];//停止定位
//地理反编码
    CLLocation *currentLocation = [locations lastObject];
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

        } else if (error == nil && placemarks.count == 0 ) {
        } else if (error) {
            self.currentCity = @"⟳定位获取失败,点击重试";
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
}

@end

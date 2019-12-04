//
//  LBOCBDViewControllerVM.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/4.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCBDViewControllerVM.h"

static NSString *baiduMapPermisionWithKey = @"3cbe52cb0365801546ded14569447d6d";

@interface LBOCBDViewControllerVM ()<BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager; /**  定位对象  */
@property (nonatomic, copy) LBOCBDUploadLocationInfoBlock uploadBlock;/** 属性block */


@end

@implementation LBOCBDViewControllerVM

- (BOOL)startMapManager{
    // 初始化定位SDK
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:baiduMapPermisionWithKey authDelegate:self];
    //要使用百度地图，请先启动BMKMapManager
    //启动引擎并设置并设置delegate
    BOOL result = [[BMKMapManager sharedInstance] start:baiduMapPermisionWithKey generalDelegate:self];
    if (result) {
        NSLog(@"启动引擎成功");
        if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
            NSLog(@"经纬度类型设置成功");
        } else {
            NSLog(@"经纬度类型设置失败");
        }
        //开启定位服务 ，采用百度地图定位manager类
        __weak __typeof(self)weakSelf = self;
        [self.locationManager requestLocationWithReGeocode:NO withNetworkState:NO
                                           completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            if(error == NULL){
                weakSelf.userLocation.location  = location.location;
            }
        }];
    }else{
        NSLog(@"启动引擎失败");
    }
    
    return result;
}

- (void)registerUploadLocationInfoBlock :(LBOCBDUploadLocationInfoBlock)block{
    self.uploadBlock = block;
}

#pragma mark —————BMKGeneralDelegate—————
- (void)onGetNetworkState:(int)iError{
}

- (void)onGetPermissionState:(int)iError{
}

#pragma mark —————BMKLocationAuthDelegate—————
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
}

#pragma mark —————BMKLocationManagerDelegate—————
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error{
    NSLog(@"定位失败");
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading{
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    self.uploadBlock(self.userLocation);
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    NSLog(@"定位成功，纬度 == %f，经度 == %f",location.location.coordinate.latitude,location.location.coordinate.longitude);
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    self.uploadBlock(self.userLocation);
}


#pragma mark —————Lazy loading—————
- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
    _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
    _locationManager = [[BMKLocationManager alloc] init];
    _locationManager.delegate = self;
    }
    return _locationManager;
}

@end

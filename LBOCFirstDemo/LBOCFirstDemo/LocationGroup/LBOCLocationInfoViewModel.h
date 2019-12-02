//
//  LBOCLocationInfoViewModel.h
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/2.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>//引入Corelocation框架
NS_ASSUME_NONNULL_BEGIN

@interface LBOCLocationInfoViewModel : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;//设置manager
@property (nonatomic, strong) NSString *currentCity;

@end

NS_ASSUME_NONNULL_END

//
//  ViewController.h
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/11/28.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>//引入Corelocation框架
#import "Masonry.h"

@interface LBOCViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;//设置manager
@property (nonatomic, strong) NSString *currentCity;


@end


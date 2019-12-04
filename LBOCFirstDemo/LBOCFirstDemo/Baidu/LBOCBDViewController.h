//
//  LBOCBDViewController.h
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/3.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LBOCBDViewControllerVM.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "LBOCBDRouteAnnotation.h"
#import "LBOCHappyMapAnnotation.h"
#import "UIImage+Rotate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LBOCBDViewController : UIViewController<BMKRouteSearchDelegate,BMKMapViewDelegate>

@property (nonatomic, strong) LBOCBDViewControllerVM *mainViewModel; /**  主ViewModel  */
@property (nonatomic, strong) BMKMapView *mapView; /** 当前界面的mapView   */
@property (nonatomic, strong) BMKRouteSearch *routesearch; /**  寻路类  */
@property (nonatomic, strong) UITextView *navTextView;

@end

NS_ASSUME_NONNULL_END

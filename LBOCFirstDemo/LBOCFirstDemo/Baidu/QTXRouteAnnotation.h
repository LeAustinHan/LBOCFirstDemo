//
//  QTXRouteAnnotation.h
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/3.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** BMKLocationCoordinateType 枚举坐标系类型
 *
 */
typedef NS_ENUM(NSUInteger, QTXRouteAnnotationType)
{
    QTXRouteAnnotationWalk = 0,           ///骑行
    QTXRouteAnnotationDrive,        ///驾车
    QTXRouteAnnotationBus,           ///公交 2
    QTXRouteAnnotationBike,           ///骑行
    
};

NS_ASSUME_NONNULL_BEGIN

@interface QTXRouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  
@property (nonatomic) NSInteger type;

@property (nonatomic) NSInteger degree;

//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;

@end

NS_ASSUME_NONNULL_END

//
//  QTXRouteAnnotation.h
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/3.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBOCBDRouteAnnotation : BMKPointAnnotation

@property (nonatomic) NSInteger type;/** <0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点   */

@property (nonatomic) NSInteger degree;
/**

获取单例

@return 获取该RouteAnnotation对应的BMKAnnotationView

*/
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;

@end

NS_ASSUME_NONNULL_END

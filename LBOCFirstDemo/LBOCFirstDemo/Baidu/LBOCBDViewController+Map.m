//
//  LBOCBDViewController+Map.m
//  LBOCFirstDemo
//
//  Created by Han Jize on 2019/12/4.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import "LBOCBDViewController+Map.h"


@implementation LBOCBDViewController (Map)

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[LBOCBDRouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(LBOCBDRouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(LBOCBDRouteAnnotation*)QTXRouteAnnotation{
    NSString *tempText = self.navTextView.text;
    self.navTextView.text = [NSString stringWithFormat:@"%@\n%@",tempText,QTXRouteAnnotation.title];
    self.navTextView.hidden = NO;
    
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


@end

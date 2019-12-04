//
//  LBOCBDViewControllerVM.h
//  LBOCFirstDemo
//  主要是定位逻辑，纯功能，与视图无关
//  Created by Han Jize on 2019/12/4.
//  Copyright © 2019 LBOC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LBOCHappyLocationManager.h"

typedef  void (^LBOCBDUploadLocationInfoBlock )(BMKUserLocation * _Nullable userLocation);

NS_ASSUME_NONNULL_BEGIN

@interface LBOCBDViewControllerVM : NSObject

@property (nonatomic, strong) BMKUserLocation *userLocation; /**  当前位置对象  */


- (BOOL)startMapManager;

/**

*  注册GPS定位结果回调block

*

*  @param block GPS定位结果回调block

*/

- (void)registerUploadLocationInfoBlock :(LBOCBDUploadLocationInfoBlock)block;

@end

NS_ASSUME_NONNULL_END

//
//  JH_PrivateHelper.h
//  haoqibaoyewu
//
//  Created by hyjt on 2017/3/24.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface JH_PrivateHelper : NSObject
/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;
/**
 * 检查系统"定位服务"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkLocationAuthorizationStatus;
/**
 * 检查系统"相机和麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (void)checkServiceEnable:(void(^)(BOOL))result;
@end

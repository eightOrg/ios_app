//
//  JH_PrivateHelper.m
//  haoqibaoyewu
//
//  Created by hyjt on 2017/3/24.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import "JH_PrivateHelper.h"
@import AVFoundation;

@implementation JH_PrivateHelper

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}
/**
 * 检查系统"定位服务"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkLocationAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->定位服务”中打开本应用的访问权限"];
        //定位不能用
        return NO;
    }
    return YES;
}
+ (void)checkServiceEnable:(void(^)(BOOL))result{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            JHdispatch_async_main_safe(^{
                if (granted) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
                    }else{
                        if (result) {
                            result(YES);
                        }
                    }
                }
                else {
                    [self showSettingAlertStr:@"请在iPhone的“设置->隐私->麦克风”中打开本应用的访问权限"];
                }
                
            });
        }];
    }
}
+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
    //        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tipStr];
    //        [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    //        [alertView bk_addButtonWithTitle:@"设置" handler:nil];
    //        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
    //            if (index == 1) {
    //                UIApplication *app = [UIApplication sharedApplication];
    //                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //                if ([app canOpenURL:settingsURL]) {
    //                    [app openURL:settingsURL];
    //                }
    //            }
    //        }];
    //        [alertView show];
    //    }else{
    kTipAlert(@"%@", tipStr);
    //    }
}
@end

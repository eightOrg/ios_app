//
//  JHAlertControllerTool.h
//  carFinance
//
//  Created by 江弘 on 2017/4/16.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAlertControllerTool : NSObject

/**
 //没有取消按钮(确认后有回调)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle  confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler viewController:(UIViewController *)vc;

/**
 //有取消按钮(确认后有回调，取消后有回调)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle  confirmHandler:(void(^)(UIAlertAction *action))confirmHandler cancleHandler:(void(^)(UIAlertAction *action))cancleHandler viewController:(UIViewController *)vc;
@end

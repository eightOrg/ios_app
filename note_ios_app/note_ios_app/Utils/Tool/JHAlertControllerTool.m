//
//  JHAlertControllerTool.m
//  carFinance
//
//  Created by 江弘 on 2017/4/16.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHAlertControllerTool.h"

@implementation JHAlertControllerTool

/**
 //没有取消按钮(确认后有回调)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle  confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler viewController:(UIViewController *)vc
{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:confirmActionHandler];
    
    [alertController addAction:confirmAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
    
}

/**
 //有取消按钮(确认后有回调，取消后有回调)
 */

+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle  confirmHandler:(void(^)(UIAlertAction *action))confirmHandler cancleHandler:(void(^)(UIAlertAction *action))cancleHandler viewController:(UIViewController *)vc
{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:confirmHandler];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
    
}
@end

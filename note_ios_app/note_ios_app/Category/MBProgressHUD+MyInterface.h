//
//  MBProgressHUD+MyInterface.h
//  carFinance
//
//  Created by hyjt on 2017/4/19.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (MyInterface)
+ (MBProgressHUD *)MBProgressShowProgressWithTitle:(NSString *)title view:(UIView *)view;
/**
 successHud
 */
+ (MBProgressHUD *)MBProgressShowSuccess:(BOOL )success WithTitle:(NSString *)title view:(UIView *)view;
/**
 hubProgress
 */
+ (MBProgressHUD *)MBProgressShowProgressViewWithTitle:(NSString *)title view:(UIView *)view;
@end

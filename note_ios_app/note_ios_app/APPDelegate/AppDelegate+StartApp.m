//
//  AppDelegate+StartApp.m
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "AppDelegate+StartApp.h"
#import "JHLoginVC.h"
#import "JHBaseNav.h"
#include "JHBaseRootVC.h"
@implementation AppDelegate (StartApp)

/**
 启动视图的一些默认设置
 */
-(void)_startApplication{
    [self _setBaseColor];
    [self _selecetRootVC];
    [self _setIQKeyboardManager];
}
/**
 选择启动试图
 */
-(void)_selecetRootVC{
    /*-------->设置窗口<--------*/
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    设置窗口背景为主背景色,处理了某些动画会出现短暂黑色背景的尴尬
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //判断用户是否保存登录
    bool isLogin = false;
    if (!isLogin) {
        JHLoginVC *login = [[JHLoginVC alloc] init];
        JHBaseNav *nav = [[JHBaseNav alloc] initWithRootViewController:login];
        self.window.rootViewController = nav;
    }else{
        JHBaseRootVC *root = [[JHBaseRootVC alloc] init];
        self.window.rootViewController = root;
    }
    
}

/**
 设置控件基础的颜色
 */
-(void)_setBaseColor{
    //设置导航栏颜色字体
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor: BaseColor];
    
    
    //    //隐藏返回按钮上的文字
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
    //                                                         forBarMetrics:UIBarMetricsDefault];
    
    //设置输入框属性
    
    
}

/**
 设置IQkeyBoard启动
 */
-(void)_setIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable                              = YES;
    manager.shouldResignOnTouchOutside          = YES;
    manager.enableAutoToolbar                   = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
}
@end

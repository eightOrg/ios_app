//
//  JH_CommonInterface.m
//  carFinance
//
//  Created by hyjt on 2017/4/12.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JH_CommonInterface.h"

@implementation JH_CommonInterface
//从资源包中加载不会占内存
+(UIImage *)LoadImageFromBundle:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName
                                                     ofType:nil];
    
    return [UIImage imageWithContentsOfFile:path];
}
/**
 获取当前视图

 @return UIViewController
 */
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
/**
 获取viewController
 */
+(UIViewController *)viewController :(UIResponder *)response{
    
    UIResponder *next = response.nextResponder;
    while(next !=nil){
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

/**
 获取keyWindows
 */
+(UIWindow *)getKeyWindows{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
#define MAX_IMAGE_WH JHSCREENWIDTH/2
/*
 判断图片长度&宽度
 
 */
+(CGSize)imageShowSize:(UIImage *)image{
    
    CGFloat imageWith=image.size.width;
    CGFloat imageHeight=image.size.height;
    
    //宽度大于高度
    if (imageWith>=imageHeight) {
        // 宽度超过标准宽度
        /*
         if (imageWith>MAX_IMAGE_WH) {
         
         }else{
         
         }
         */
        
        
        return CGSizeMake(MAX_IMAGE_WH, imageHeight*MAX_IMAGE_WH/imageWith);
        
        
    }else{
        /*
         if (imageHeight>MAX_IMAGE_WH) {
         
         }else{
         
         }
         */
        
        
        return CGSizeMake(imageWith*MAX_IMAGE_WH/imageHeight, MAX_IMAGE_WH);
        
    }
    
    
    
    
    
    return CGSizeZero;
}
@end

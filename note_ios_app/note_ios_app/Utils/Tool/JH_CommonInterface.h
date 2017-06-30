//
//  JH_CommonInterface.h
//  carFinance
//
//  Created by hyjt on 2017/4/12.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface JH_CommonInterface : NSObject
//从资源包中加载不会占内存
+(UIImage *)LoadImageFromBundle:(NSString *)imageName;
/**
 获取当前视图
 
 @return UIViewController
 */
+ (UIViewController *)presentingVC;

/**
 获取viewController
 */
+(UIViewController *)viewController :(UIResponder *)response;

/*
 判断图片长度&宽度
 
 */
+(CGSize)imageShowSize:(UIImage *)image;

@end

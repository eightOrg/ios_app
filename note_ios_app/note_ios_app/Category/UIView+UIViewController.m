//
//  UIView+UIViewController.m
//  新浪微博
//
//  Created by mac10 on 15/10/16.
//  Copyright (c) 2015年 黄翔宇. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)
/**
 获取UIView的UIViewController控制器
 */
-(UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    while(next !=nil){
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end

//
//  JHWebViewController.h
//  JH_WebTest
//
//  Created by hyjt on 2017/3/17.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface JHWebViewController : UIViewController
@property (nonatomic,copy)NSString * urlString;
@property (nonatomic,strong)UIColor * progressTintColor;
@property(nonatomic,copy)NSString *tpl;
@property(nonatomic,copy)NSString *activeId;
@end

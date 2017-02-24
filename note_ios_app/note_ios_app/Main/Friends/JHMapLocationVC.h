//
//  JHMapLocationVC.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/23.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^LocationBlock)(double latitude, double longitude);

@interface JHMapLocationVC : UIViewController

@property(nonatomic,strong)LocationBlock locationBlock;

#pragma mark - 开启导航功能
@property(nonatomic,strong)CLLocation *userLocation;
@end

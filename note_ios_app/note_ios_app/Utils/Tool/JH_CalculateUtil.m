//
//  JH_CalculateUtil.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/24.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_CalculateUtil.h"

@implementation JH_CalculateUtil




#define PI                      3.1415926
#define EARTH_RADIUS            6378.137        //地球近似半径

double radian(double d);
double get_distance(double lat1, double lng1, double lat2, double lng2);

// 求弧度
double radian(double d)
{
    return d * PI / 180.0;   //角度1˚ = π / 180
}

//计算距离
double get_distance(double lat1, double lng1, double lat2, double lng2)
{
    double radLat1 = radian(lat1);
    double radLat2 = radian(lat2);
    double a = radLat1 - radLat2;
    double b = radian(lng1) - radian(lng2);
    
    double dst = 2 * asin((sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2) )));
    
    dst = dst * EARTH_RADIUS;
    dst= round(dst * 10000) / 10000;
    return dst;
}
//计算中心点
double get_center(double first, double sencond)
{
    
    return (first+sencond)/2;
}

/**
 根据两点经纬度计算距离
 
 @param latitude1 纬度1
 @param longitude1 经度1
 @param latitude2 纬度2
 @param longitude2 经度2
 @return 返回距离M
 */
+(double)getDistanceByLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double)latitude2 longitude2:(double)longitude2{
    
    double dst = get_distance(latitude1, longitude1, latitude2, longitude2);
    printf("dst = %0.3fkm\n", dst);  
    return dst*1000;
}
@end

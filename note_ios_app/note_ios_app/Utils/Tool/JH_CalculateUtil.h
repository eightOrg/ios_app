//
//  JH_CalculateUtil.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/24.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JH_CalculateUtil : NSObject

/**
 根据两点经纬度计算距离

 @param latitude1 纬度1
 @param longitude1 经度1
 @param latitude2 纬度2
 @param longitude2 经度2
 @return 返回距离M
 */
+(double)getDistanceByLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double)latitude2 longitude2:(double)longitude2;
@end

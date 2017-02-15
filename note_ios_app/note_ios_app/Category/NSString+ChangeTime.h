//
//  NSString+ChangeTime.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/8/4.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChangeTime)
//精确到天
+(NSString *)changeTimeIntervalToDate:(NSNumber *)timeInterval;
//精确到秒
+(NSString *)changeTimeIntervalToSecond:(NSNumber *)timeInterval;
/**
 将时间戳转换成月日时分
 */
+(NSString *)changeTimeIntervalToMinuteWithoutYear:(NSNumber *)timeInterval;

/**
 改变时间戳到分:秒

 @param timeInterval NSNumber
 @return //返回HH:mm
 */
+(NSString *)changeTimeIntervalToMinute:(NSNumber *)timeInterval;
/**
 改变时间戳到分:秒
 
 @param date NSString
 @return //返回number类型
 */
+(NSNumber *)changeTimeDateToInterval:(NSString *)date;
#pragma 判断时间，区分为今天、昨天、其他
+ (NSString *)compareTimeReturnUserTime:(NSNumber *)time;
@end

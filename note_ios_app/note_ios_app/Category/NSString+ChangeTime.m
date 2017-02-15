//
//  NSString+ChangeTime.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/8/4.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "NSString+ChangeTime.h"

@implementation NSString (ChangeTime)
/**
 将时间戳转换成年月日格式
 */
+(NSString *)changeTimeIntervalToDate:(NSNumber *)timeInterval{
//实例化一个NSDateFormatter对象
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//设定时间格式,这里可以设置成自己需要的格式
[dateFormatter setDateFormat:@"yyyy-MM-dd"];
//用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr;
    //有时候时间戳是13位，有时候是10位
    if ([timeInterval longLongValue]/1000000000==1) {
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]]];
    }else{
        
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000.0]];
    }

//输出格式为：2010-10-27
return currentDateStr;
}
/**
 将时间戳转换成年月日时分秒
 */
+(NSString *)changeTimeIntervalToSecond:(NSNumber *)timeInterval{
//实例化一个NSDateFormatter对象
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//设定时间格式,这里可以设置成自己需要的格式
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr;    //有时候时间戳是13位，有时候是10位
    if ([timeInterval longLongValue]/1000000000==1) {
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]]];
    }else{
        
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000.0]];
    }


return currentDateStr;
}
/**
 将时间戳转换成月日时分
 */
+(NSString *)changeTimeIntervalToMinuteWithoutYear:(NSNumber *)timeInterval{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr;    //有时候时间戳是13位，有时候是10位
    if ([timeInterval longLongValue]/1000000000==1) {
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]]];
    }else{
        
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000.0]];
    }
    
    
    return currentDateStr;
}
/**
 将时间戳转换成时分
 */
+(NSString *)changeTimeIntervalToMinute:(NSNumber *)timeInterval{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr;    //有时候时间戳是13位，有时候是10位
    if ([timeInterval longLongValue]/1000000000==1) {
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]]];
    }else{
        
        currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000.0]];
    }
    
    
    return currentDateStr;
}
/**
 将年月日转换成13位时间戳
 */
//返回number
+(NSNumber *)changeTimeDateToInterval:(NSString *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
   NSDate *thisDate = [dateFormatter dateFromString:date];
//    NSInteger timeInterval = [NSTimeInterval time thisDate ]
   NSTimeInterval time =  [thisDate timeIntervalSince1970];
    NSNumber *timeInterval = @(time);
    //有时候时间戳是13位，有时候是10位
    if ([timeInterval longLongValue]/1000000000==1) {
        return @(time*1000);
    }else{
        return @(time);
    }
    

}

#pragma 判断时间，区分为今天、昨天、其他
+ (NSString *)compareTimeReturnUserTime:(NSNumber *)time{
    long timeInterval = [time longValue];
    //将时间戳精确到秒
    if (timeInterval/1000000000==1) {
    }else{
        timeInterval = timeInterval/1000;
    }
    //获取当前时间
    NSDate *nowData = [NSDate date];
    long timeNow = [nowData timeIntervalSince1970];
    //将时间戳精确到秒
    if (timeNow/1000000000==1) {
    }else{
        timeNow = timeNow/1000;
    }
    //对比时间（是否是今天）返回时分
    if ([[[self class] changeTimeIntervalToDate:time] isEqualToString:[[self class] changeTimeIntervalToDate:@(timeNow)]]) {
        return [[self class]changeTimeIntervalToMinute:time];
    }
    //对比是否是昨天
    if ([[[self class] changeTimeIntervalToDate:time] isEqualToString:[[self class] changeTimeIntervalToDate:@(timeNow-24*60*60)]]) {
        return [NSString stringWithFormat:@"昨天 %@",[[self class]changeTimeIntervalToMinute:time]];
    }
    //其他情况
    
    return [[self class]changeTimeIntervalToMinuteWithoutYear:time];
}

@end

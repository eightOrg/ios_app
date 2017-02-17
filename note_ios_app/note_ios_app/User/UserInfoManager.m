//
//  UserInfoManager.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/17.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "UserInfoManager.h"
static  NSString *JH_UserId = @"JH_UserId";
static  NSString *JH_UserName = @"JH_UserName";
@implementation UserInfoManager

/**
 设置用户id到plist文件中
 
 @param userId NSString
 */
+(void)_setUserId:(NSString *)userId{
    [JH_FileManager setObjectToUserDefault:userId ByKey:JH_UserId];
}

/**
 设置用户名称到plist文件中
 
 @param userName NSString
 */
+(void)_setUserName:(NSString *)userName;{
    [JH_FileManager setObjectToUserDefault:userName ByKey:JH_UserName];
}

/**
 获取用户id
 
 @return 用户id
 */
+(NSString *)getUserId;{
    return [JH_FileManager getObjectFromUserDefaultByKey:JH_UserId];
}

/**
 获取用户姓名
 
 @return 用户姓名
 */
+(NSString *)getUserName;{
    
    return [JH_FileManager getObjectFromUserDefaultByKey:JH_UserName];
}
@end

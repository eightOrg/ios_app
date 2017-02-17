//
//  UserInfoManager.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/17.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

/**
 设置用户id到plist文件中

 @param userId NSString
 */
+(void)_setUserId:(NSString *)userId;

/**
 设置用户名称到plist文件中

 @param userName NSString
 */
+(void)_setUserName:(NSString *)userName;

/**
 获取用户id

 @return 用户id
 */
+(NSString *)getUserId;

/**
 获取用户姓名

 @return 用户姓名
 */
+(NSString *)getUserName;
@end

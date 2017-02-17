//
//  JH_FileManager.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/16.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JH_FileManager : NSObject

/**
 设置数据到用户plist文件中

 @param key NSString
 */
+(void)setObjectToUserDefault:(id)object ByKey:(NSString *)key;

/**
 获取plist文件数据

 @param key NSString
 @return object
 */
+(id)getObjectFromUserDefaultByKey:(NSString *)key;

/**
 删除plist文件

 @param key NSString
 */
+(void)removeObjectFromUserDefaultByKey:(NSString *)key;

//返回缓存根目录 "caches"
+(NSString *)getCachesDirectory;

//返回根目录路径 "document"
+ (NSString *)getDocumentPath;

//创建文件夹
+(BOOL)creatDir:(NSString*)dirPath;

//删除文件夹
+(BOOL)deleteDir:(NSString*)dirPath;

//移动文件夹
+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath;

//创建文件
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data;

//读取文件
+(NSData*)readFile:(NSString *)filePath;

//删除文件
+(BOOL)deleteFile:(NSString *)filePath;

//返回 文件全路径
+ (NSString*)getFilePath:(NSString*) fileName;

//在对应文件保存数据
+ (BOOL)writeDataToFile:(NSString*)fileName data:(NSData*)data;

//从对应的文件读取数据
+ (NSData*)readDataFromFile:(NSString*)fileName;
@end

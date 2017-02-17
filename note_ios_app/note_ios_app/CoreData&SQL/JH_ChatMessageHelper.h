//
//  JH_ChatMessageHelper.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JH_ChatMessageManager.h"
@interface JH_ChatMessageHelper : NSObject
#pragma mark - 添加数据
+(void)_addNewData:(NSDictionary *)data;
#pragma mark - 删除数据
+(void)_deleteData:(NSArray *)objectResults;
#pragma mark - 查询数据(暂时使用全部搜索)
+(NSArray *)_searchData;
#pragma mark - 更新数据
+(void)_updateData:(M_RecentMessage *)data;

#pragma mark - 查询单个用户历史信息数据(暂时使用全部搜索)
+(NSArray *)_searchDataByUserId:(NSString *)userId;
#pragma mark - 新建一个用户，用于数据传递，但不更新数据库
+(M_RecentMessage *)creatDefaultRecentMessageWithUserId :userId userName:userName;

@end

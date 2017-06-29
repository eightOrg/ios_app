//
//  JH_ChatMessageHelper.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JH_ChatMessageManager.h"
/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageTypeText=0,
    MessageTypeVoice,
    MessageTypeImage,
    MessageTypeLocation
    
};


/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderTypeReceived=0,
    MessageSenderTypeSend
    
};
@interface JH_ChatMessageHelper : NSObject
#pragma mark - 添加数据
+(void)_addNewData:(NSDictionary *)data;
/**
 创建一条信息
 */
+(M_MessageList *)_addNewMessageForUser:(NSString *)user withData:(NSDictionary *)oneMessage;
#pragma mark - 删除数据
+(void)_deleteData:(NSArray *)objectResults;
#pragma mark - 查询数据(暂时使用全部搜索)
+(NSArray *)_searchData;
/**
 限定数量查询数据
 
 @param limit 限定数量
 */
+(NSArray *)_searchDataWithLimit:(NSInteger)limit;
#pragma mark - 更新数据
+(void)_updateData:(M_RecentMessage *)data;

#pragma mark - 查询单个用户历史信息数据(暂时使用全部搜索)
+(NSArray *)_searchDataByUserId:(NSString *)userId;
#pragma mark - 新建一个用户，用于数据传递，但不更新数据库
+(M_RecentMessage *)creatDefaultRecentMessageWithUserId :userId userName:userName;

@end

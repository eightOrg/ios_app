//
//  JH_ChatMessageHelper.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ChatMessageHelper.h"
#define kManagedObjectContext [JH_ChatMessageManager sharedInstance].managedObjectContext
#define JH_M_UserInfo @"M_UserInfo"
#define JH_M_RecentMessage @"M_RecentMessage"
#define JH_M_MessageList @"M_MessageList"
@implementation JH_ChatMessageHelper
#pragma mark - 添加数据
+(void)_addNewData:(NSDictionary *)data{
    
    //首先判断这个用户是否已经存在数据库，若存在则进行关联表的增加，而不是全部新增数据,且不为自己
    NSArray *baseData = [[self class]_searchData];
    for (M_RecentMessage *recentMessage in baseData) {
        //当存在和插入数据相同的id直接退出
        if (recentMessage.recentMessage_user.user_id == [data[@"user"][@"id"] longLongValue]) {
            for (NSDictionary *oneMessage in data[@"user"][@"messages"]) {
                
                M_MessageList *message = [NSEntityDescription insertNewObjectForEntityForName:JH_M_MessageList inManagedObjectContext:kManagedObjectContext];
                message.message_time = [oneMessage[@"time"] longLongValue];
                message.message_type = [oneMessage[@"type"] longLongValue];
                message.message_text = oneMessage[@"text"];
                message.message_path = oneMessage[@"path"];
                message.message_isSelf = [oneMessage[@"isSelf"]isEqual:@1]?true:false;
                [recentMessage.recentMessage_user addUser_messageObject:message];
            }
            //同步数据库
            [[JH_ChatMessageManager sharedInstance] saveContext]; //插入 保存

            //不让他执行之后的操作
            return;
        }
    }
    //新建一个用户
    
    M_RecentMessage *recentMessage = [NSEntityDescription insertNewObjectForEntityForName:JH_M_RecentMessage inManagedObjectContext:kManagedObjectContext];
    M_UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:JH_M_UserInfo inManagedObjectContext:kManagedObjectContext];
    
    
    //添加消息列表
    NSArray *messages = data[@"user"][@"messages"];
    for (NSDictionary *oneMessage in messages) {
        M_MessageList *message = [NSEntityDescription insertNewObjectForEntityForName:JH_M_MessageList inManagedObjectContext:kManagedObjectContext];
        message.message_time = [oneMessage[@"time"] longLongValue];
        message.message_type = [oneMessage[@"type"] longLongValue];
        message.message_text = oneMessage[@"text"];
        message.message_path = oneMessage[@"path"];
        message.message_isSelf = [oneMessage[@"isSelf"]isEqual:@1]?true:false;
        message.message_user = userInfo;
        [userInfo addUser_messageObject:message];
    }
    NSDictionary *oneUser = data[@"user"];
    //添加用户信息
    userInfo.user_id       = [oneUser[@"id"] longLongValue];
    userInfo.user_name     = oneUser[@"name"];
    userInfo.user_portrail = oneUser[@"portrail"];
    recentMessage.recentMessage_user = userInfo;
    userInfo.user_recentMessage = recentMessage;
    //添加最近消息列表
    recentMessage.recent_message_time = [data[@"time"] longLongValue];
    recentMessage.recent_message_num  = [data[@"num"] longLongValue];;
    recentMessage.recentMessage_user = userInfo;
    
    //同步数据库
    [[JH_ChatMessageManager sharedInstance] saveContext]; //插入 保存
    
    NSLog(@"%@",NSHomeDirectory());
    
}
#pragma mark - 删除数据
+(void)_deleteData:(NSArray *)objectResults{
    if (objectResults && objectResults.count > 0 ) {
        
        for (NSManagedObject *object in objectResults) {
            
            [kManagedObjectContext deleteObject:object];
            
        }
        [[JH_ChatMessageManager sharedInstance] saveContext]; //删除之后 保存
        
    }
}
#pragma mark - 查询数据(暂时使用全部搜索)
+(NSArray *)_searchData{
    /**
     数据查询数据（全部）
     */
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:JH_M_RecentMessage
                                       
                                                  inManagedObjectContext:kManagedObjectContext];
        
        [request setEntity:entity];
        
        NSError *error = nil;
        
        NSArray *objectResults = [kManagedObjectContext
                                  
                                  executeFetchRequest:request
                                  
                                  error:&error];
        return objectResults;
        
}
#pragma mark - 查询单个用户历史信息数据(暂时使用全部搜索)
+(NSArray *)_searchDataByUserId:(NSString *)userId{
    NSFetchRequest *request = [M_RecentMessage fetchRequest];
    
    //设置查询条件
    //使用谓词NSPredicate  添加查询条件 相当于sqlite中的sql语句
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"recentMessage_user.user_id = %@",userId]];
    
    if (predicate) [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *objectResults = [kManagedObjectContext
                              
                              executeFetchRequest:request
                              
                              error:&error];
    
    return objectResults;
}

#pragma mark - 更新数据
+(void)_updateData:(M_RecentMessage *)data{
    
}

#pragma mark - 新建一个用户，用于数据传递，但不更新数据库
+(M_RecentMessage *)creatDefaultRecentMessageWithUserId :userId userName:userName{
    
    M_RecentMessage *recentMessage = [NSEntityDescription insertNewObjectForEntityForName:JH_M_RecentMessage inManagedObjectContext:kManagedObjectContext];
    M_UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:JH_M_UserInfo inManagedObjectContext:kManagedObjectContext];
    
    //添加消息列表

    //添加用户信息
    userInfo.user_id       = [userId longLongValue];
    userInfo.user_name     = userName;
//    userInfo.user_portrail = ;
    recentMessage.recentMessage_user = userInfo;
    userInfo.user_recentMessage = recentMessage;
    //添加最近消息列表
    recentMessage.recentMessage_user = userInfo;

    return recentMessage;
}


@end

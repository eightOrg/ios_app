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
    
    //首先判断这个用户是否已经存在数据库，若存在则进行关联表的增加，而不是全部新增数据
    NSArray *baseData = [[self class]_searchData];
    for (M_RecentMessage *recentMessage in baseData) {
        //当存在和插入数据相同的id直接退出
        if (recentMessage.recentMessage_user.user_id == [data[@"user"][@"id"] integerValue]) {
            for (NSDictionary *oneMessage in data[@"user"][@"messages"]) {
                
                M_MessageList *message = [NSEntityDescription insertNewObjectForEntityForName:JH_M_MessageList inManagedObjectContext:kManagedObjectContext];
                message.message_time = [oneMessage[@"time"] integerValue];
                message.message_type = [oneMessage[@"type"] integerValue];
                message.message_text = oneMessage[@"text"];
                message.message_path = oneMessage[@"path"];
                [recentMessage.recentMessage_user addUser_messageObject:message];
            }
            //同步数据库
            [[JH_ChatMessageManager sharedInstance] saveContext]; //插入 保存

            //不让他执行之后的操作
            return;
        }
    }
    
    
    /*
     建立字典结构{
     time 
     num
     user:{
            id
            name
            potrail
            messages:[
                        {
                        time
                        type
                        text
                        path
                        }
                    ]
            }
     }
     **/
    
    M_RecentMessage *recentMessage = [NSEntityDescription insertNewObjectForEntityForName:JH_M_RecentMessage inManagedObjectContext:kManagedObjectContext];
    M_UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:JH_M_UserInfo inManagedObjectContext:kManagedObjectContext];
    
    
    //添加消息列表
    NSArray *messages = data[@"user"][@"messages"];
    for (NSDictionary *oneMessage in messages) {
        M_MessageList *message = [NSEntityDescription insertNewObjectForEntityForName:JH_M_MessageList inManagedObjectContext:kManagedObjectContext];
        message.message_time = [oneMessage[@"time"] integerValue];
        message.message_type = [oneMessage[@"type"] integerValue];
        message.message_text = oneMessage[@"text"];
        message.message_path = oneMessage[@"path"];
        message.message_user = userInfo;
        [userInfo addUser_messageObject:message];
    }
    NSDictionary *oneUser = data[@"user"];
    //添加用户信息
    userInfo.user_id       = [oneUser[@"id"] integerValue];
    userInfo.user_name     = oneUser[@"name"];
    userInfo.user_portrail = oneUser[@"portrail"];
    recentMessage.recentMessage_user = userInfo;
    userInfo.user_recentMessage = recentMessage;
    //添加最近消息列表
    recentMessage.recent_message_time = [data[@"time"] integerValue];
    recentMessage.recent_message_num  = [data[@"num"] integerValue];;
    recentMessage.recentMessage_user = userInfo;
    
    //同步数据库
    [[JH_ChatMessageManager sharedInstance] saveContext]; //插入 保存
    
    Dlog(@"%@",NSHomeDirectory());
    
}
#pragma mark - 删除数据
+(void)_deleteData:(NSArray *)objectResults{
    
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
#pragma mark - 更新数据
+(void)_updateData:(M_RecentMessage *)data{
    
}
#pragma mark - 建立表关联
+(void)_relationWithTable{
    
    
}

@end

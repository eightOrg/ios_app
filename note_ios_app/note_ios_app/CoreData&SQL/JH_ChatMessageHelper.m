//
//  JH_ChatMessageHelper.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ChatMessageHelper.h"
#define kManagedObjectContext [JH_ChatMessageManager sharedInstance].managedObjectContext
@implementation JH_ChatMessageHelper
#pragma mark - 添加数据
+(void)_addNewData:(NSDictionary *)data{
    
}
#pragma mark - 删除数据
+(void)_deleteData:(NSArray *)objectResults{
    
}
#pragma mark - 查询数据(暂时使用全部搜索)
+(NSArray *)_searchData{
    return nil;
}
#pragma mark - 更新数据
+(void)_updateData:(M_RecentMessage *)data{
    
}
#pragma mark - 建立表关联
+(void)_relationWithTable{
    
}

@end

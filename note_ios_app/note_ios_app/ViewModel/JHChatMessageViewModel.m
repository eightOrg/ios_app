//
//  JHChatMessageViewModel.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatMessageViewModel.h"
#import "JH_ChatMessageHelper.h"
#import "NSString+ChangeTime.h"
@interface JHChatMessageViewModel ()
@property(nonatomic,strong)JHChatMessageCell *chatFriendCell;
@property(nonatomic,strong)NSMutableArray *chatMessageData;
@end
@implementation JHChatMessageViewModel
/**
 加载数据并给model和cell赋值
 
 @param resultBlock result
 */
-(void)CF_LoadData:(void(^)(id result))resultBlock{
    
    NSMutableArray *list = [NSMutableArray array];
    NSArray *data = [JH_ChatMessageHelper _searchData];
    for (M_RecentMessage *recentMessage in data) {
        M_UserInfo *user = recentMessage.recentMessage_user;
        //将集合转成数组
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"message_time" ascending:YES]];
        NSArray *sortSetArray = [user.user_message sortedArrayUsingDescriptors:sortDesc];
        M_MessageList *lastMessage = [sortSetArray lastObject];
        
        NSDictionary *oneMessageDic = @{
                                            @"name":user.user_name,
                                            @"resentMessage":lastMessage.message_text,
                                            @"time":[NSString changeTimeIntervalToMinute:@(recentMessage.recent_message_time)],
                                            @"number":[[NSString alloc] initWithFormat:@"%lld",recentMessage.recent_message_num],
                                            @"portrail":user.user_portrail==nil?@"p0.jpg":user.user_portrail,
                                            };
        
        [list addObject:oneMessageDic];

    }
    
    _chatMessageData = [[NSMutableArray alloc] init];
    for (NSDictionary *group in list) {
        //行数据model
        JHChatMessageModel *messageModel = [JHChatMessageModel mj_objectWithKeyValues:group];
        //添加model
        [_chatMessageData addObject:messageModel];
    }
    resultBlock(data);
}
/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)CF_numberOfRow{
    return _chatMessageData.count;
}

/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(JHChatMessageCell *)setUpTableViewCell:(NSIndexPath *)indexPath{
    JHChatMessageModel *rowModel = _chatMessageData[indexPath.row];
    JHChatMessageItem *item      = [[JHChatMessageItem alloc] init];
    //将model数据赋值给item
    item.name          = rowModel.name;
    item.time          = rowModel.time;
    item.portrail      = rowModel.portrail;
    item.resentMessage = rowModel.resentMessage;
    item.number        = rowModel.number;
    JHChatMessageCell *cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JHChatMessageCell class]) owner:self options:nil]lastObject];
    [cell _setChatMessageModel:item];
    
    return cell;
    
}

@end

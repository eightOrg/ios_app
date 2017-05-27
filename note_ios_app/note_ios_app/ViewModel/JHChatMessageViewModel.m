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
#import "JHChatBaseController.h"
@interface JHChatMessageViewModel ()
@property(nonatomic,strong)JHChatMessageCell *chatFriendCell;

@end
@implementation JHChatMessageViewModel

/**
 加载数据并给model和cell赋值
 
 @param resultBlock result
 */

-(void)JH_loadTableDataWithData:(NSDictionary *)data :(void (^)())resultBlock{
    NSMutableArray *list = [NSMutableArray array];
    NSArray *messageData = [JH_ChatMessageHelper _searchData];
    _chatMessageModelList = messageData;
    for (M_RecentMessage *recentMessage in messageData) {
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
                                        @"type":@(lastMessage.message_type),
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
    resultBlock(messageData);
}

/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)JH_numberOfRow:(NSInteger)section{
    
    return _chatMessageData.count;
}
/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(UITableViewCell *)JH_setUpTableViewCell:(NSIndexPath *)indexPath{
    JHChatMessageModel *rowModel = _chatMessageData[indexPath.row];
    JHChatMessageItem *item      = [[JHChatMessageItem alloc] init];
    //将model数据赋值给item
    item.type          = rowModel.type;
    item.name          = rowModel.name;
    item.time          = rowModel.time;
    item.portrail      = rowModel.portrail;
    item.resentMessage = rowModel.resentMessage;
    item.number        = rowModel.number;
    JHChatMessageCell *cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JHChatMessageCell class]) owner:self options:nil]lastObject];
    [cell _setChatMessageModel:item];
    
    return cell;
}
-(void)didSelectRowAndPush:(NSIndexPath *)indexPath vcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav{
    JHChatBaseController *chat = [[JHChatBaseController alloc] init];
    chat.hidesBottomBarWhenPushed = YES;
    //创建ViewModel
    JHChatBaseViewModel *viewModel = [[JHChatBaseViewModel alloc] init];
    viewModel.recentMessage = self.chatMessageModelList[indexPath.row];
    chat.viewModel = viewModel;
    [nav pushViewController:chat animated:YES];
    
}

@end

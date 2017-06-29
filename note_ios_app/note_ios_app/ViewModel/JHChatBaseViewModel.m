//
//  JHChatBaseViewModel.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseViewModel.h"

@implementation JHChatBaseViewModel


-(void)JH_loadTableDataWithData:(NSDictionary *)data completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock{
    M_UserInfo *user = self.recentMessage.recentMessage_user;
    //进行数据的排序
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"message_time" ascending:YES]];
    NSArray *sortSetArray = [user.user_message sortedArrayUsingDescriptors:sortDesc];
    
    _messageList = [[NSMutableArray alloc] initWithArray:sortSetArray];
    completionblock(nil);
    
}
/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)JH_numberOfRow:(NSInteger)section{
    
    return _messageList.count;
}
-(UITableViewCell *)JH_setUpTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    M_MessageList *message = _messageList[indexPath.row];

    UITableViewCell *cell = [JHChatBaseCell cellWithTableView:tableView messageModel:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)JH_heightForCell:(NSIndexPath *)indexPath{
    CGFloat height = [JHChatBaseCell tableHeightWithModel:_messageList[indexPath.row]];
    return height;
}
-(void)disSelectRowWithIndexPath:(NSIndexPath *)indexPath WithHandle:(void (^)(id result))completionBlock{
    M_MessageList *message = _messageList[indexPath.row];
    
    completionBlock(@(message.message_type));
}
#pragma mark - 数据处理
/**
 发送通知用于消息页面的数据更新
 */
-(void)sendNotificationForDataFresh{
    [[NSNotificationCenter defaultCenter]postNotificationName:JH_ChatMessageFreshNotification object:nil];
}
/**
 添加数据
 */
-(void)_setMessageDictionary:(NSString *)textOfPath isPath:(BOOL )isPath isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    NSDictionary *dic = @{
                          @"time":time,
                          @"num":@"0",
                          @"user":@{
                                  @"id":userId,
                                  @"name":userName,
                                  @"potrail":isSelf?@"":@"",
                                  @"messages":@[
                                          @{
                                              @"time":time,
                                              @"type":@(type),
                                              @"text":isPath?@"":textOfPath,
                                              @"path":isPath?textOfPath:@"",
                                              @"isSelf":isSelf?@1:@0,
                                              @"isShowTime":@1,
                                              }
                                          ]
                                  }
                          };

    //插入数据库
    [JH_ChatMessageHelper _addNewData:dic];
    
    NSArray *messages = dic[@"user"][@"messages"];
    //插入页面数据
    M_MessageList *newMessage = [JH_ChatMessageHelper _addNewMessageForUser:nil withData:messages[0]];
    [_messageList addObject:newMessage];
    //消息页面数据更新
    [self sendNotificationForDataFresh];
    
}
//添加文字信息
- (void)addTextMessage:(NSString *)text isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    //存储数据库
    [self _setMessageDictionary:text isPath:NO isSelf:isSelf userId:userId userName:userName time:time type:MessageTypeText];
}
//添加定位信息(123/123)中间分隔为“/”
- (void)addLocationMessage:(NSString *)locationString isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type completionBlock:(void (^)())completion{
    //将locationString分解
//    NSArray *locationArray = [locationString componentsSeparatedByString:@"/"];
//    
    //存储数据库
    [self _setMessageDictionary:locationString isPath:NO isSelf:isSelf userId:userId userName:userName time:time type:MessageTypeLocation];
    
    completion();
    
}
@end

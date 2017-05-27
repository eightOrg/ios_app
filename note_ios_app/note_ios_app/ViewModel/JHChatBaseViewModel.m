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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    M_MessageList *message = _messageList[indexPath.row];
    UITableViewCell *cell = [JHChatBaseCell cellWithTableView:tableView messageModel:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)JH_heightForCell:(NSIndexPath *)indexPath{
    CGFloat height = [JHChatBaseCell tableHeightWithModel:_messageList[indexPath.row]];
    return height;
}
-(void)disSelectRowWithIndexPath:(NSIndexPath *)indexPath WithHandle:(void (^)())completionBlock{
    
    completionBlock();
}
@end

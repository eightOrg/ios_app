//
//  JHChatMessageViewModel.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatMessageViewModel.h"
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
#warning 测试数据用户列表
    NSArray *data = @[@{
                          @"name":@"蒋小红1",
                          @"resentMessage":@"最新信息1",
                          @"time":@"18:18",
                          @"number":@"40",
                          @"portrail":@"",
                          },
                      @{
                          @"name":@"蒋小红2",
                          @"resentMessage":@"最新信息2",
                          @"time":@"18:18",
                          @"number":@"40",
                          @"portrail":@"",
                          },
                      @{
                          @"name":@"蒋小红3",
                          @"resentMessage":@"最新信息1",
                          @"time":@"18:18",
                          @"number":@"99+",
                          @"portrail":@"",
                          },
                      ];
    _chatMessageData = [[NSMutableArray alloc] init];
    for (NSDictionary *group in data) {
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
    JHChatMessageModel *rowModel = _chatMessageData[indexPath.section];
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

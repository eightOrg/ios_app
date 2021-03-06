//
//  JHChatFriendViewModel.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatFriendViewModel.h"
#import "JHChatBaseController.h"
@interface JHChatFriendViewModel()<JHCahtFriendGroupDelegate>
@property(nonatomic,strong)JHChatFriendCell *chatFriendCell;
@property(nonatomic,strong)NSMutableArray *chatFriendData;
@end
@implementation JHChatFriendViewModel
-(void)JH_loadTableDataWithData:(NSDictionary *)data :(void (^)())resultBlock{
#warning 测试数据用户列表
    NSArray *testData = @[@{
                          @"groupName":@"分组一",
                          @"groupDetail":@[
                                  @{@"userId":@"100",
                                    @"name":@"用户1-1",
                                    @"portrait":@"",
                                    @"point":@"80"
                                    },
                                  @{@"userId":@"101",
                                    @"name":@"用户1-2",
                                    @"portrait":@"",
                                    @"point":@"100"
                                    }
                                  ]
                          },
                      @{
                          @"groupName":@"分组二",
                          @"groupDetail":@[
                                  @{
                                      @"userId":@"102",
                                      @"name":@"用户2-1",
                                      @"portrait":@"",
                                      @"point":@"70"
                                      },
                                  @{
                                      @"userId":@"103",
                                      @"name":@"用户2-2",
                                      @"portrait":@"",
                                      @"point":@"100"
                                      }
                                  ]
                          },
                      @{
                          @"groupName":@"分组三",
                          @"groupDetail":@[
                                  @{
                                      @"userId":@"104",
                                      @"name":@"用户3-1",
                                      @"portrait":@"",
                                      @"point":@"83"
                                      },
                                  @{
                                      @"userId":@"105",
                                      @"name":@"用户3-2",
                                      @"portrait":@"",
                                      @"point":@"99"
                                      }
                                  ]
                          }
                      ];
    _chatFriendData = [[NSMutableArray alloc] init];
    for (NSDictionary *group in testData) {
        //行数据model
        JHChatFriendSectionModel *sectionModel = [JHChatFriendSectionModel mj_objectWithKeyValues:group];
        //默认为折叠
        sectionModel.isFold = YES;
        
        sectionModel.rowModel = [[NSMutableArray alloc] init];
        //列数据model
        for (NSDictionary *friend in sectionModel.groupDetail) {
            JHChatFriendRowModel *rowModel = [JHChatFriendRowModel mj_objectWithKeyValues:friend];
            [sectionModel.rowModel addObject:rowModel];
        }
        //添加model
        [_chatFriendData addObject:sectionModel];
    }
    resultBlock(testData);
}


/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)JH_numberOfSection{
    return _chatFriendData.count;
}
/**
 将列数放回给VC
 
 @param section 行数
 @return 列数
 */

-(NSInteger)JH_numberOfRow:(NSInteger)section{
    JHChatFriendSectionModel *model = _chatFriendData[section];
    if (model.isFold == YES) {
        return 0;
    }
    return model.rowModel.count;
}
/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(UITableViewCell *)JH_setUpTableViewCell:(NSIndexPath *)indexPath{
    JHChatFriendSectionModel *sectionModel = _chatFriendData[indexPath.section];
    JHChatFriendRowModel *rowModel = sectionModel.rowModel[indexPath.row];
    JHChatFriendItem *item = [[JHChatFriendItem alloc] init];
    //将model数据赋值给item
    item.name     = rowModel.name;
    item.point    = rowModel.point;
    item.portrait = rowModel.portrait;
    
    JHChatFriendCell *cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JHChatFriendCell class]) owner:self options:nil]lastObject];
    [cell _setChatFriendModel:item];
    
    return cell;
}
/**
 根据组创建头视图
 
 @param section 组数
 @return JHChatFriendGroupView
 */
-(UIView *)JH_setUpTableSectionHeader:(NSInteger)section{
    //获取title
    JHChatFriendSectionModel *sectionModel = _chatFriendData[section];
    NSString *title = sectionModel.groupName;
    JHChatFriendGroupView *groupView = [[JHChatFriendGroupView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, 30) withTitle:title withFold:sectionModel.isFold];
    groupView.section = section;
    groupView.delegate = self;
    
    return groupView;
}

-(void)_setGroupFold:(JHChatFriendGroupView *)view byIdentity:(BOOL)isFold{
    //todo改变tableView的展开收起
    //1.首先改变数据
    JHChatFriendSectionModel *sectionModel = [[JHChatFriendSectionModel alloc] init];
    sectionModel = _chatFriendData[view.section];
    sectionModel.isFold = !isFold;
    [_chatFriendData replaceObjectAtIndex:view.section withObject:sectionModel];
    
    //2.刷新数据
    [[NSNotificationCenter defaultCenter]postNotificationName:JH_ChatFriendFreshNotification object:self userInfo:@{@"section":@(view.section)}];
    
}
/**
 选中事件
 */
-(void)didSelectRowAndPush:(NSIndexPath *)indexPath vcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav{
    //查询最近数据
    M_RecentMessage *message = [[JH_ChatMessageHelper _searchDataByUserId:[self getUserId:indexPath]]lastObject];
    
    JHChatBaseController *chat = [[JHChatBaseController alloc] init];
    JHChatBaseViewModel *viewModel = [[JHChatBaseViewModel alloc] init];
    
    if (message==nil) {
        //创建一个空数据
        M_RecentMessage *defaultMessage = [JH_ChatMessageHelper creatDefaultRecentMessageWithUserId:[self getUserId:indexPath] userName:[self getUserName:indexPath]];
        viewModel.recentMessage = defaultMessage;
    }else{
        viewModel.recentMessage = message;
    }
    chat.viewModel = viewModel;
    
    chat.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:chat animated:YES];
    
}

/**
 获取当前位置的用户id

 @param indexPath NSIndexPath
 @return NSString
 */
-(NSString *)getUserId:(NSIndexPath *)indexPath{
    JHChatFriendSectionModel *sectionModel = _chatFriendData[indexPath.section];
    JHChatFriendRowModel *rowModel = sectionModel.rowModel[indexPath.row];
    return rowModel.userId;
}
/**
 获取当前位置的用户name
 
 @param indexPath NSIndexPath
 @return NSString
 */
-(NSString *)getUserName:(NSIndexPath *)indexPath{
    JHChatFriendSectionModel *sectionModel = _chatFriendData[indexPath.section];
    JHChatFriendRowModel *rowModel = sectionModel.rowModel[indexPath.row];
    return rowModel.name;
}
@end

//
//  JHChildFriendsVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/1.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHChildFriendsVC.h"
#import "JHChatFriendViewModel.h"
#import "JH_SearchView.h"
#import "JH_JSQBaseChatVC.h"
@interface JHChildFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JHChatFriendViewModel *viewModel;
@property(nonatomic,strong)JH_SearchView *searchBar;
@end
static CGFloat searchBarHeight = 40;
static CGFloat rowBarHeight = 50;
static CGFloat headerHeight = 40;
/**
 好友列表，分组，同时点击可展开
 */
@implementation JHChildFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[JHChatFriendViewModel alloc] init];
    [_viewModel CF_LoadData:^(id result) {
        
        [self.view addSubview:self.tableView];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshNotification:) name:JH_ChatFriendFreshNotification object:nil];
}

/**
 刷新数据

 @param noti NSNotification
 */
-(void)freshNotification:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSNumber *section = userInfo[@"section"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[section integerValue]] withRowAnimation:0];
}
#pragma mark - searchBar
-(JH_SearchView *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[JH_SearchView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, searchBarHeight)];
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    return _searchBar;
}
#pragma mark - tableView
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT-JH_NavigationHeight-JH_ToolBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchBar;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_viewModel CF_numberOfSection];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_viewModel CF_numberOfRow:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [_viewModel setUpTableViewCell:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowBarHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [_viewModel _creatJHChatFriendGroupView:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
#pragma mark - 选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //查询最近数据
    M_RecentMessage *message = [[JH_ChatMessageHelper _searchDataByUserId:[_viewModel getUserId:indexPath]]lastObject];
    
    JH_JSQBaseChatVC *chat = [[JH_JSQBaseChatVC alloc] init];
    
    if (message==nil) {
        //创建一个空数据
       M_RecentMessage *defaultMessage = [JH_ChatMessageHelper creatDefaultRecentMessageWithUserId:[_viewModel getUserId:indexPath] userName:[_viewModel getUserName:indexPath]];
        chat.baseMessages = defaultMessage;
    }else{
        chat.baseMessages = message;
    }
    
    
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
}


@end

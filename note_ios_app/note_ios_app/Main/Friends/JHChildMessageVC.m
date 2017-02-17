//
//  JHChildMessageVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/1.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHChildMessageVC.h"
#import "JHChatMessageViewModel.h"
#import "JH_DIYsearchBar.h"
#import "JH_JSQBaseChatVC.h"
@interface JHChildMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JHChatMessageViewModel *viewModel;
@property(nonatomic,strong)JH_DIYsearchBar *searchBar;
@property(nonatomic,strong)NSArray *messageData;
@end
static CGFloat searchBarHeight = 40;
static CGFloat rowBarHeight = 70;
static CGFloat headerHeight = 0.1;
@interface JHChildMessageVC ()

@end

@implementation JHChildMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[JHChatMessageViewModel alloc] init];
    [_viewModel CF_LoadData:^(id result) {
        _messageData = result;
        [self.view addSubview:self.tableView];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_freshAction) name:JH_ChatMessageFreshNotification object:nil];
}

/**
 刷新数据
 */
-(void)_freshAction{
    
    [_viewModel CF_LoadData:^(id result) {
    _messageData = result;
    [self.tableView reloadData];
    }];
    
}

#pragma mark - searchBar
-(JH_DIYsearchBar *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[JH_DIYsearchBar alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, searchBarHeight)];
        _searchBar.placeholder = @"搜索";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_viewModel CF_numberOfRow];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
#pragma mark - 选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JH_JSQBaseChatVC *chat = [[JH_JSQBaseChatVC alloc] init];
    chat.hidesBottomBarWhenPushed = YES;
    chat.baseMessages = _messageData[indexPath.row];
    [self.navigationController pushViewController:chat animated:YES];
    
}
#pragma mark - 给这个列表添加删除事件
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
/**
 添加左划删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    M_RecentMessage *message = _messageData[indexPath.row];
    // 从数据库中删除
    [JH_ChatMessageHelper _deleteData:@[message]];
    // 从文件中删除
    //获取路径
    NSString *path = [NSString stringWithFormat:@"%lld",message.recentMessage_user.user_id];
    //删除文件夹
    [JH_FileManager deleteDir:[NSString stringWithFormat:@"%@/%@",[JH_FileManager getDocumentPath],path]];
    Dlog(@"%@",NSHomeDirectory());
    // 从列表中删除
    [self _freshAction];
    
}
@end

//
//  JHChildMessageVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/1.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHChildMessageVC.h"
#import "JHChatMessageViewModel.h"
#import "JH_SearchView.h"
#import "JH_JSQBaseChatVC.h"

@interface JHChildMessageVC ()<UITableViewDelegate,UITableViewDataSource,JHSearchBarDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JHChatMessageViewModel *viewModel;
@property(nonatomic,strong)JH_SearchView *searchBar;
//@property(nonatomic,strong)NSArray *messageData;
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

    [self.view addSubview:self.tableView];
    [self _freshAction];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_freshAction) name:JH_ChatMessageFreshNotification object:nil];
    
}

/**
 刷新数据
 */
-(void)_freshAction{
    [_viewModel JH_loadTableDataWithData:nil :^{
        
        [self.tableView reloadData];
    }];
    
}

#pragma mark - searchBar
-(JH_SearchView *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[JH_SearchView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, searchBarHeight)withPlaceHold:@"搜索"];
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
    return [_viewModel JH_numberOfRow:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [_viewModel JH_setUpTableViewCell:indexPath];
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
    [_viewModel didSelectRowAndPush:indexPath vcName:nil dic:nil nav:self.navigationController];
    
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
    M_RecentMessage *message = _viewModel.chatMessageModelList[indexPath.row];
    
    // 从文件中删除
    //获取路径
    NSString *path = [NSString stringWithFormat:@"%lld",message.recentMessage_user.user_id];
    //删除文件夹
    [JH_FileManager deleteDir:[NSString stringWithFormat:@"%@/%@",[JH_FileManager getDocumentPath],path]];
    NSLog(@"%@",NSHomeDirectory());
    // 从数据库中删除
    [JH_ChatMessageHelper _deleteData:@[message]];
    // 从列表中删除
    [self _freshAction];
    
}
/**
 当输入文字改变的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchTextDidChange:(JH_SearchView *)searchbar
{

}
/**
 当点击搜索的代理
 
 @param searchbar JH_SearchView
 */
-(void)_searchBarSearch:(JH_SearchView *)searchbar{
    
}

@end

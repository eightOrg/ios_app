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
@interface JHChildMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JHChatMessageViewModel *viewModel;
@property(nonatomic,strong)JH_DIYsearchBar *searchBar;
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
        
        [self.view addSubview:self.tableView];
    }];
    
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
@end

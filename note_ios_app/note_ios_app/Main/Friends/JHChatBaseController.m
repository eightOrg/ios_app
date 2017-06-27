//
//  JHChatBaseController.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseController.h"

@interface JHChatBaseController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation JHChatBaseController
#pragma mark - system (systemMethod override)
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"聊天主界面";
    if (!_viewModel) {
        
        _viewModel = [[JHChatBaseViewModel alloc] init];
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self _freshData];
}
#pragma mark - UI (creatSubView and layout)
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_viewModel JH_numberOfRow:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [_viewModel JH_setUpTableViewCell:tableView indexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_viewModel JH_heightForCell:indexPath];
}
/**
 选中
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_viewModel disSelectRowWithIndexPath:indexPath WithHandle:^{
        
    }];
    
}
#pragma mark - utilMethod

/**
 刷新数据
 */
-(void)_freshData{
    WeakSelf
    [_viewModel JH_loadTableDataWithData:nil completionHandle:^(id result) {
        
        [weakSelf.tableView reloadData];
        
    } errorHandle:^(NSError *error) {
        
    }];
    
}


@end

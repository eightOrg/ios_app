//
//  JHChatBaseController.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseController.h"
#import "JHInputView.h"
#import <IQKeyboardManager.h>
@interface JHChatBaseController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,JH_ChatSendDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)JHInputView *inputView;
@end
const static CGFloat inputViewHeight=90;
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
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, inputViewHeight, 0));
    }];
    _inputView = [[JHInputView alloc] initWithFrame:CGRectMake(0, self.view.bottom-inputViewHeight-JH_NavigationHeight, self.view.frame.size.width, inputViewHeight)];
    _inputView.sendDelegate = self;
    [self.view addSubview:_inputView];
    
    [self _freshData];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma mark - UI (creatSubView and layout)
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetY = scrollView.contentOffset.y;

//    [self.view endEditing:YES];
    
}

/**
 发送文字信息
 */
-(void)JHsendMessageWithText:(NSString *)text{
    NSString *userId = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    NSString *userName = self.viewModel.recentMessage.recentMessage_user.user_name;
    NSDate *now = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%f",[now timeIntervalSince1970]];
    [self.viewModel addTextMessage:text isSelf:YES userId:userId userName:userName time:time type:MessageTypeText];
    [self.tableView reloadData];
}
#pragma mark - utilMethod
/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y;
    
 
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        self.tableView.frame = CGRectMake(0, 0, JHSCREENWIDTH, transformY-JH_NavigationHeight-inputViewHeight);
        self.tableView.bottom = transformY-inputViewHeight-JH_NavigationHeight;
        self.inputView.bottom = transformY-JH_NavigationHeight;
        [self scrollTableViewToBottom];
    }completion:^(BOOL finished) {
        
    }];
}
/**
 *  tableView快速滚动到底部
 */
- (void)scrollTableViewToBottom {
    if (self.viewModel.messageList.count>0) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.viewModel.messageList.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
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

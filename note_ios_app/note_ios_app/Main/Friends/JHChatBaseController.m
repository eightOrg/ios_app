//
//  JHChatBaseController.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseController.h"
#import "JHInputView.h"
#import "JHMapLocationVC.h"
#import <IQKeyboardManager.h>
#import "JHImageViewerWindow.h"
@interface JHChatBaseController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,JH_ChatSendDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
    _inputView.userId  = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    [self.view addSubview:_inputView];
    
    [self _freshData];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        [self _sendImage:image];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    WeakSelf
    //增加图片选择确定的视图
    JHImageViewerWindow *imageWindows = [[JHImageViewerWindow alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT) WithImage:image];
    [imageWindows _setCancelAndCertainButton];
    [picker.view addSubview:imageWindows];
    
    [imageWindows setBlock:^(UIImage *img){
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [weakSelf _sendImage:image];
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
    WeakSelf
    [_viewModel disSelectRowWithIndexPath:indexPath WithHandle:^(id result){
        M_MessageList *message = weakSelf.viewModel.messageList[indexPath.row];
        if ([result isEqual:@(MessageTypeLocation)]) {
            NSArray *locationArr = [message.message_text componentsSeparatedByString:@"/"];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationArr[0] doubleValue] longitude:[locationArr[1] doubleValue]];
            JHMapLocationVC *locationVC = [[JHMapLocationVC alloc] init];
            locationVC.userLocation = location;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:locationVC];
            [weakSelf.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }else if ([result isEqual:@(MessageTypeImage)]){
            //获取图片
            NSString *documentPath = [JH_FileManager getDocumentPath];
            NSString *imagePath = message.message_path;
            
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",documentPath,imagePath]];
            JHImageViewerWindow *imageWindow = [[JHImageViewerWindow alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT) WithImage:image];
            [imageWindow _setOneTapDismissGesture];
            [imageWindow _setDoubleTapGesture];
            [weakSelf.navigationController.view addSubview:imageWindow];
        }
        
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetY = scrollView.contentOffset.y;

//    [self.view endEditing:YES];
    
}

/**
 发送录音

 @param dir 录音路径
 */
-(void)JHsendMessageWithAudioDir:(NSString *)dir{
    NSString *userId = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    NSString *userName = self.viewModel.recentMessage.recentMessage_user.user_name;
    NSDate *now = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[now timeIntervalSince1970]];
    [self.viewModel addAudioMediaMessage:dir isSelf:YES userId:userId userName:userName time:time type:MessageTypeVoice];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.viewModel.messageList.count-1 inSection:0]] withRowAnimation:0];
    [self.view endEditing:YES];
    [self scrollTableViewToBottom];
}
/**
 发送文字信息
 */
-(void)JHsendMessageWithText:(NSString *)text{

    NSString *userId = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    NSString *userName = self.viewModel.recentMessage.recentMessage_user.user_name;
    NSDate *now = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[now timeIntervalSince1970]];
    [self.viewModel addTextMessage:text isSelf:YES userId:userId userName:userName time:time type:MessageTypeText];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.viewModel.messageList.count-1 inSection:0]] withRowAnimation:0];
    [self.view endEditing:YES];
    
}
/**
 发送定位
 */
-(void)JHsendMessageWithLocationWithLatitude:(double)latitude withlongitude:(double)longitude{
    NSString *userId = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    NSString *userName = self.viewModel.recentMessage.recentMessage_user.user_name;
    NSDate *now = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[now timeIntervalSince1970]];
    NSString *locationStr = [NSString stringWithFormat:@"%f/%f",latitude,longitude];
    WeakSelf
    [self.viewModel addLocationMessage:locationStr isSelf:YES userId:userId userName:userName time:time type:MessageTypeLocation completionBlock:^{
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.viewModel.messageList.count-1 inSection:0]] withRowAnimation:0];
    }];
    [self.view endEditing:YES];
    [self scrollTableViewToBottom];
}
/**
 发送图片信息
 */
-(void)JHsendMessageWithImage:(UIImagePickerController *)picker{
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - utilMethod

/**
 发送图片

 @param image UIImage
 */
-(void)_sendImage:(UIImage *)image{
    NSString *userId = [NSString stringWithFormat:@"%lld",self.viewModel.recentMessage.recentMessage_user.user_id];
    NSString *userName = self.viewModel.recentMessage.recentMessage_user.user_name;
    NSDate *now = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[now timeIntervalSince1970]];
    
    [self.viewModel addPhotoMediaMessage:image isSelf:YES userId:userId userName:userName time:time type: MessageTypeImage];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.viewModel.messageList.count-1 inSection:0]] withRowAnimation:0];
    [self.view endEditing:YES];
    [self scrollTableViewToBottom];
}

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
        [weakSelf scrollTableViewToBottom];
    } errorHandle:^(NSError *error) {
        
    }];
    
}


@end

//
//  JH_JSQBaseChatVC.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_JSQBaseChatVC.h"
#import <GCDAsyncSocket.h>
#import "JH_ChatSendMessageView.h"
#import "JHImageViewerWindow.h"
@interface JH_JSQBaseChatVC ()<GCDAsyncSocketDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JH_ChatCameraDelegate,JH_ChatAudioDelegate,JH_ChatLocationDelegate>
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;// 客户端链接的Socket

@end

@implementation JH_JSQBaseChatVC


- (void)dealloc
{
    NSLog(@"dealloc--->%s",object_getClassName(self));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //将好友名称作为导航栏标题
    self.title = self.baseMessages.recentMessage_user.user_name;
    
    // 键盘上面的那个toolbar
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    /**
     *  Load up our fake data for the demo
     */
    // 初始化fake消息模型
    self.chatData = [[JH_JSQBaseChatModel alloc] init];
    self.chatData.baseMessages = self.baseMessages;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_freshAction:) name:JH_ChatNotification object:nil];
    //加载已有数据
    [self.chatData loadFakeMessages];
        //设置头像
    [self _setPotrail];
    
    
    // 注册custom按钮，允许自定义
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    
    
    /**
     *  OPT-IN: allow cells to be deleted
     */
    // 注册delelte按钮，允许被删除
//    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
  
    
}

/**
 刷新数据
 */
-(void)_freshAction:(NSNotification *)notify{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[notify.userInfo[@"itemIndex"] integerValue] inSection:0]]];
//    [self finishSendingMessage];
}

-(void)_setPotrail{
            JSQMessagesAvatarImage *myImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"p0.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
            JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"p0.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
//     这里的数组决定了是几个人在聊天 dict  key ： value(avatar)
            self.chatData.avatars = @{ self.senderId : myImage,
                              [NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] : cookImage,
                               };
    
            // 用户姓名  key ： value （name）
            self.chatData.users = @{ self.senderId : self.senderDisplayName,
                            [NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] : self.baseMessages.recentMessage_user.user_name
                            };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    // 一个bubbles的移动动画效果
    self.collectionView.collectionViewLayout.springinessEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"kDynamic"] boolValue];
}

#pragma mark - Custom menu actions for cells
// 自定义action的文案按钮
- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    /**
     *  Display custom menu actions for cells.
     */
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    [super didReceiveMenuWillShowNotification:notification];
}


#pragma mark - Actions
// 收到别人发的消息了
- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  DEMO ONLY
     *
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = YES;
    
    /**
     *  Scroll to actually view the indicator 滚动到最后
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    JSQMessage *copyMessage = [[self.chatData.messages lastObject] copy];
    
    if (!copyMessage) {
//        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
//                                          displayName:kJSQDemoAvatarDisplayNameJobs
//                                                 text:@"First received!"];
    }
    
    /**
     *  Allow typing indicator to show
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *userIds = [[self.chatData.users allKeys] mutableCopy];
        [userIds removeObject:self.senderId];
        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
        
        JSQMessage *newMessage = nil;
        id<JSQMessageMediaData> newMediaData = nil;
        id newMediaAttachmentCopy = nil;
        
        // JSQMessage对应的BOOL isMediaMessage = NO就是text，YES就是图片，音频，视频，定位
        if (copyMessage.isMediaMessage) {
            /**
             *  Last message was a media message
             */
            // 先把代理存储下
            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
            
            // 如果是图片
            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
                // 默认都是YES的，这句话的意思是气泡的小尖尖朝哪个方向，YES是发出去的，就朝右，反之
                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view
                 *  代表发出去的消息会进行短暂的loading
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                // 坐标消息  同上
                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [locationItemCopy.location copy];
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                // 视频消息 同上
                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = NO;
                
                newMediaData = videoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                // 同上
                JSQAudioMediaItem *audioItemCopy = [((JSQAudioMediaItem *)copyMediaData) copy];
                audioItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [audioItemCopy.audioData copy];
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            }
            else {
                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
            }
            
            // 除开Text外的消息类
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.chatData.users[randomUserId]
                                                   media:newMediaData];
        }
        else {
            /**
             *  Last message was a text message  消息类
             */
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.chatData.users[randomUserId]
                                                    text:copyMessage.text];
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        // [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        
        // 播放声音
        [self.chatData.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
        
        
        // 如果消息类型是Media  非文本形式
        if (newMessage.isMediaMessage) {
            /**
             *  Simulate "downloading" media  模拟下载
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
                        [self.collectionView reloadData];
                    }];
                }
                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                    ((JSQAudioMediaItem *)newMediaData).audioData = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else {
                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
                }
                
            });
        }
        
    });
}


#pragma mark - JSQMessagesViewController method overrides
// 纯文本发送
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    [self.chatData addTextMessage:text isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] type:MessageTypeText];
    
    [self finishSendingMessageAnimated:YES];
}

/**
 发送定位的代理
 @param latitude 经度
 @param longitude 纬度
 */
-(void)setLocationWith:(double)latitude longtitude:(double)longitude{
    __weak UICollectionView *weakView = self.collectionView;
    //组合locationString
    NSString *locationString = [NSString stringWithFormat:@"%f/%f",latitude,longitude];
    [self.chatData addLocationMessage:locationString isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] type:MessageTypeLocation completionBlock:^{
        //刷新视图
        [weakView reloadData];
    }];
    [self finishSendingMessageAnimated:YES];
    
}

// 点击左侧accessory按钮启动，打开附加信息页面
- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    JH_ChatSendMessageView *media = [[JH_ChatSendMessageView alloc] initWithFrame:CGRectMake(0, JHSCREENHEIGHT-JHSCREENWIDTH/4, JHSCREENWIDTH, JHSCREENWIDTH/4)];
    //传递userId
    media.userId = [NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id];
    media.cameraDelegate = self;
    media.audioDelegate = self;
    media.locationDelegate = self;
    media.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:media];
   
}
#pragma mark - 录音文件处理
-(void)stopRecord:(NSString *)recorderPath{
    //插入录音数据，已存储在沙盒
    [self.chatData addAudioMediaMessage:recorderPath isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:recorderPath type:MessageTypeAudio];
    
    
    [self finishSendingMessage];
}
#pragma mark -相册相关的处理
-(void)setCamera:(UIImagePickerController *)picker{
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //增加图片选择确定的视图
    JHImageViewerWindow *imageWindows = [[JHImageViewerWindow alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT) WithImage:image];
    [imageWindows _setCancelAndCertainButton];
    [picker.view addSubview:imageWindows];
    
    [imageWindows setBlock:^(UIImage *img){
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        //获取原始图片
        //开启编辑后
        //    UIImage *image = info[UIImagePickerControllerEditedImage];
        //将图片插入数据库
        [self.chatData addPhotoMediaMessage:image isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] type:MessageTypePhoto];
        
        [self finishSendingMessage];
        
    }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 此处需要获取本人的id信息
// 发送的人ID
- (NSString *)senderId {
    return [UserInfoManager getUserId];
}
// 发送人名字
- (NSString *)senderDisplayName {
    return [UserInfoManager getUserName];
}
// 根据index返回需要加载的message对象
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatData.messages objectAtIndex:indexPath.item];
}

// 删除消息
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatData.messages removeObjectAtIndex:indexPath.item];
}

// 聊天气泡，根据ID判断是发送的还是接受的
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.chatData.outgoingBubbleImageData;
    }
    
    return self.chatData.incomingBubbleImageData;
}

// 头像
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    return [self.chatData.avatars objectForKey:message.senderId];
}

// 时间UI
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

// 除本人以外显示bubble cell上面的名字
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chatData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

// 气泡cell底部文字
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chatData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    JSQMessage *msg = [self.chatData.messages objectAtIndex:indexPath.item];
    //文字颜色
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    // 是否是自定义的action
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

// 自定义弹框
- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

// cell气泡上面的时间高度，出来就给默认20  3个给一个
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

// cell气泡上面的人名字高度  发送人不需要  和上一个重名也不需要  不然默认给20
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chatData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chatData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

// cell底部展示文案的高度
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events
//加载更多
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}
//点击头像
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}
//点击信息
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
    //获取点击对象(当为图片的时候展示大图)
    JSQMessage *jsqMessage = self.chatData.messages[indexPath.row];
    if (jsqMessage.isMediaMessage) {
        JSQMediaItem *item = (JSQMediaItem *)jsqMessage.media;
        if ([item isKindOfClass:[JSQPhotoMediaItem class]]) {
            JSQPhotoMediaItem *photoItem = (JSQPhotoMediaItem *)item;
            JHImageViewerWindow *imageWindow = [[JHImageViewerWindow alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT) WithImage:photoItem.image];
            [self.navigationController.view addSubview:imageWindow];
        }
    }
    
}

// 点击cell边缘头部或者底部的 时间或者名字点击事件
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

// 粘贴的是Media的话就自己配置返回NO，YES就是发送文字（黏贴图片？）
- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        
        [self.chatData addPhotoMediaMessage:[UIPasteboard generalPasteboard].image isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] type:MessageTypePhoto];
        
        [self finishSendingMessage];
        return NO;
    }
    //插入数据库
    [self.chatData addTextMessage:textView.text isSelf:YES userId:[NSString stringWithFormat:@"%lld",self.baseMessages.recentMessage_user.user_id] userName:self.baseMessages.recentMessage_user.user_name time:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] type:MessageTypeText];
    
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

// 调用这段代码 shouldShowAccessoryButtonForMessage
// cell左右侧出现的标签按钮事件回调
- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}


@end

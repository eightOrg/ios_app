//
//  JH_JSQBaseChatModel.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_JSQBaseChatModel.h"

@implementation JH_JSQBaseChatModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
        /**
         *  Create avatar images once. 头像
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        // 头像图片制作工具类
        // 新方法
        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JH"
                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                 font:[UIFont systemFontOfSize:14.0f]
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault+10];
        JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"p0.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];;
        
        JSQMessagesAvatarImage *jobsImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"p0.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"p0.jpg"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        
        // 老方法
        //        JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        // 根据文字背景颜色切圆形图片
        //        JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:@"MKJ"
        //                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
        //                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
        //                                                                                 font:[UIFont systemFontOfSize:14.0f]];
        //
        //        JSQMessagesAvatarImage *cookImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
        //
        //        JSQMessagesAvatarImage *jobsImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]];
        //
        //        JSQMessagesAvatarImage *wozImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]];
        
        // 这里的数组决定了是几个人在聊天 dict  key ： value(avatar)
        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
                          kJSQDemoAvatarIdCook : cookImage,
                          kJSQDemoAvatarIdJobs : jobsImage,
                          kJSQDemoAvatarIdWoz : wozImage };
        
        // 用户姓名  key ： value （name）
        self.users = @{ kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
                        kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
                        kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        // 气泡图片制作工具类
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleRegularImage] capInsets:UIEdgeInsetsZero];
        // 发出去的气泡颜色
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        //        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
        // 收到的气泡颜色
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor: BaseColor];
    }
    
    return self;
}


/**
 加载已有的信息
 */
- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    self.messages =[NSMutableArray array];
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
//                                                     date:[NSDate distantPast]
//                                                     text:NSLocalizedString(@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.", nil)],
//                     
//                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdJobs
//                                        senderDisplayName:kJSQDemoAvatarDisplayNameJobs
//                                                     date:[NSDate date]
//                                                     text:NSLocalizedString(@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.", nil)],
//                     nil];
   
        M_UserInfo *user = self.baseMessages.recentMessage_user;
        for (M_MessageList *message in user.user_message) {
            switch (message.message_type) {
                    //文字
                case 0:
                {
                   JSQMessage *JSQ_Message = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",user.user_id]
                                       senderDisplayName:user.user_name
                                                    date:[NSDate dateWithTimeIntervalSince1970:message.message_time]
                                                    text:NSLocalizedString(message.message_text, nil)];
                    [self.messages addObject:JSQ_Message];
                }
                    break;
                    
                default:
                    break;
            }
    }
    
    
//    // 新增phoen对象
//    [self addPhotoMediaMessage];
//    // 新增语音对象
//    [self addAudioMediaMessage];
//    
//    // 测试视频
//    [self addVideoMediaMessageWithThumbnail];
    
    /**
     *  Setting to load extra messages for testing/demo  这个设置额外的copy出来的数据无视他
     */
    //    if ([NSUserDefaults extraMessagesSetting]) {
    //        NSArray *copyOfMessages = [self.messages copy];
    //        for (NSUInteger i = 0; i < 4; i++) {
    //            [self.messages addObjectsFromArray:copyOfMessages];
    //        }
    //    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    
    
}

// 语音
- (void)addAudioMediaMessage
{
    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"m4a"];
    NSData * audioData = [NSData dataWithContentsOfFile:sample];
    JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
    JSQMessage *audioMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:audioItem];
    [self.messages addObject:audioMessage];
}

// 图片message
- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"p0.jpg"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

// 定位信息
- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                      displayName:kJSQDemoAvatarDisplayNameSquires
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

// vidoe  黑色无底图
- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
        NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
        NSURL *videoURL = [NSURL URLWithString:path];
    
        JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
        JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                       displayName:kJSQDemoAvatarDisplayNameSquires
                                                             media:videoItem];
        [self.messages addObject:videoMessage];
}
// video 附带底图
- (void)addVideoMediaMessageWithThumbnail
{
    // don't have a real video, just pretending
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL *videoURL = [NSURL URLWithString:@"http://qingdan.img.iwala.net/v/twt/twt1612_720P.mp4"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}


@end

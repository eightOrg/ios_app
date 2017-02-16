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
   
    M_UserInfo *user = self.baseMessages.recentMessage_user;
    //进行数据的排序
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"message_time" ascending:YES]];
    NSArray *sortSetArray = [user.user_message sortedArrayUsingDescriptors:sortDesc];
        for (M_MessageList *message in sortSetArray) {
            switch (message.message_type) {
                    //文字,区分开是否为自己发送的数据
                case MessageTypeText:
                {
#warning 测试数据，假设自己用户是99
                    if (message.message_isSelf) {
                        JSQMessage *JSQ_Message = [[JSQMessage alloc] initWithSenderId:@"99"
                                                                     senderDisplayName:user.user_name
                                                                                  date:[NSDate dateWithTimeIntervalSince1970:message.message_time]
                                                                                  text:NSLocalizedString(message.message_text, nil)];
                        [self.messages addObject:JSQ_Message];
                    }else{
                        JSQMessage *JSQ_Message = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",user.user_id]
                                                                     senderDisplayName:user.user_name
                                                                                  date:[NSDate dateWithTimeIntervalSince1970:message.message_time]
                                                                                  text:NSLocalizedString(message.message_text, nil)];
                        [self.messages addObject:JSQ_Message];
                    }
                   
                }
                    break;
                case MessageTypePhoto:
                {
#warning 测试数据，假设自己用户是99
                    //获取图片
                    NSString *documentPath = [JH_FileManager getDocumentPath];
                    NSString *imagePath = message.message_path;

                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",documentPath,imagePath]];
                    if (message.message_isSelf) {
                        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
                        JSQMessage *photoMessage = [[JSQMessage alloc]initWithSenderId:@"99" senderDisplayName:user.user_name date:[NSDate dateWithTimeIntervalSince1970:message.message_time] media:photoItem];
                        [self.messages addObject:photoMessage];
                        
                    }else{
                        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
                        JSQMessage *photoMessage = [[JSQMessage alloc]initWithSenderId:[NSString stringWithFormat:@"%lld",user.user_id] senderDisplayName:user.user_name date:[NSDate dateWithTimeIntervalSince1970:message.message_time] media:photoItem];
                        [self.messages addObject:photoMessage];
                    }
                    
                }
                    break;
                default:
                    break;
            }
    }
    
    
    
}

// 语音
//- (void)addAudioMediaMessage
//{
//    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"m4a"];
//    NSData * audioData = [NSData dataWithContentsOfFile:sample];
//    JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
//    JSQMessage *audioMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:audioItem];
//    [self.messages addObject:audioMessage];
//}
//
//// 图片message
//- (void)addPhotoMediaMessage
//{
//    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"p0.jpg"]];
//    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:photoItem];
//    [self.messages addObject:photoMessage];
//}
//
//// 定位信息
//- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
//{
//    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
//    
//    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
//    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
//    
//    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                      displayName:kJSQDemoAvatarDisplayNameSquires
//                                                            media:locationItem];
//    [self.messages addObject:locationMessage];
//}
//
//// vidoe  黑色无底图
//- (void)addVideoMediaMessage
//{
//    // don't have a real video, just pretending
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
//        NSURL *videoURL = [NSURL URLWithString:path];
//    
//        JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
//        JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                       displayName:kJSQDemoAvatarDisplayNameSquires
//                                                             media:videoItem];
//        [self.messages addObject:videoMessage];
//}
//// video 附带底图
//- (void)addVideoMediaMessageWithThumbnail
//{
//    // don't have a real video, just pretending
////        NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
//    NSURL *videoURL = [NSURL URLWithString:@"http://qingdan.img.iwala.net/v/twt/twt1612_720P.mp4"];
//    
//    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
//    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:videoItem];
//    [self.messages addObject:videoMessage];
//}


@end

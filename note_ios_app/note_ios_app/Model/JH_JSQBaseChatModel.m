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
   
    self.messages =[NSMutableArray array];
    
    M_UserInfo *user = self.baseMessages.recentMessage_user;

    NSString *selfUserId = [UserInfoManager getUserId];
    //进行数据的排序
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"message_time" ascending:YES]];
    NSArray *sortSetArray = [user.user_message sortedArrayUsingDescriptors:sortDesc];
    //遍历数组
    [sortSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        M_MessageList *message = obj;
        
        switch (message.message_type) {
                //文字,区分开是否为自己发送的数据
            case MessageTypeText:
            {
                JSQMessage *JSQ_Message = [[JSQMessage alloc] initWithSenderId:message.message_isSelf?selfUserId:[NSString stringWithFormat:@"%lld",user.user_id]
                                                             senderDisplayName:user.user_name
                                                                          date:[NSDate dateWithTimeIntervalSince1970:message.message_time]
                                                                          text:NSLocalizedString(message.message_text, nil)];
                [self.messages addObject:JSQ_Message];
                
            }
                break;
            case MessageTypeImage:
            {
                //获取图片
                NSString *documentPath = [JH_FileManager getDocumentPath];
                NSString *imagePath = message.message_path;
                
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",documentPath,imagePath]];
                
                JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
                JSQMessage *photoMessage = [[JSQMessage alloc]initWithSenderId:message.message_isSelf?selfUserId:[NSString stringWithFormat:@"%lld",user.user_id] senderDisplayName:user.user_name date:[NSDate dateWithTimeIntervalSince1970:message.message_time] media:photoItem];
                [self.messages addObject:photoMessage];
                
            }
                break;
            case MessageTypeVoice:
            {
                //获取录音
                NSString *completePaht = [NSString stringWithFormat:@"%@/%@",[JH_FileManager getDocumentPath],message.message_path];
                NSData * audioData = [NSData dataWithContentsOfFile:completePaht];
                JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
                JSQMessage *audioMessage = [[JSQMessage alloc]initWithSenderId:message.message_isSelf?selfUserId:[NSString stringWithFormat:@"%lld",user.user_id] senderDisplayName:user.user_name date:[NSDate dateWithTimeIntervalSince1970:message.message_time] media:audioItem];
                [self.messages addObject:audioMessage];
                
                
            }
                break;
            case MessageTypeLocation:
            {
                //获取定位
                NSArray *locationArray = [message.message_text componentsSeparatedByString:@"/"];
                CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:[[locationArray firstObject]doubleValue ] longitude:[[locationArray lastObject]doubleValue ]];
                //locationItem
                JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
                
                [locationItem setLocation:ferryBuildingInSF withCompletionHandler:^{
                    //发送刷新的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:JH_ChatNotification object:nil userInfo:@{@"itemIndex":@(idx)}];
                }];
                JSQMessage *locationMessage = [[JSQMessage alloc ]initWithSenderId:message.message_isSelf?selfUserId:[NSString stringWithFormat:@"%lld",user.user_id] senderDisplayName:user.user_name date:[NSDate dateWithTimeIntervalSince1970:message.message_time] media:locationItem];
                
                [self.messages addObject:locationMessage];
            }
                break;
            default:
                break;
        }
    }];
    

                //让当前线程（主线程）等待直到isLocation等于isLoad数组长度的时候，才将数据返回
//                while (isLocation!=isLoad.count) {
//                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//                }
    
    
    
}

#pragma mark - 插入新数据
#pragma mark - 构建信息Dictionary
-(void)_setMessageDictionary:(NSString *)textOfPath isPath:(BOOL )isPath isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    NSDictionary *dic = @{
                          @"time":time,
                          @"num":@"0",
                          @"user":@{
                                  @"id":userId,
                                  @"name":userName,
                                  @"potrail":isSelf?@"":@"",
                                  @"messages":@[
                                          @{
                                              @"time":time,
                                              @"type":@(type),
                                              @"text":isPath?@"":textOfPath,
                                              @"path":isPath?textOfPath:@"",
                                              @"isSelf":isSelf?@1:@0,
                                              }
                                          ]
                                  }
                          };
    //插入数据库
    [JH_ChatMessageHelper _addNewData:dic];
    
    //消息页面数据更新
    [self sendNotificationForDataFresh];
    
}

//添加文字信息
- (void)addTextMessage:(NSString *)text isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    //添加本页面数据
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:isSelf?[UserInfoManager getUserId]:userId
                                             senderDisplayName:isSelf?[UserInfoManager getUserName]: userName
                                                          date:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]]
                                                          text:text];
    
    [self.messages addObject:message];

    //存储数据库
    [self _setMessageDictionary:text isPath:NO isSelf:isSelf userId:userId userName:userName time:time type:MessageTypeText];
}
//添加图片message
- (void)addPhotoMediaMessage:(UIImage *)image isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
    
    JSQMessage *photoMessage = [[JSQMessage alloc]initWithSenderId:isSelf?[UserInfoManager getUserId]:userId
                                                 senderDisplayName:isSelf?[UserInfoManager getUserName]: userName date:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]] media:photoItem];
    [self.messages addObject:photoMessage];
    //将图片存入本地
    [self _writePhoto:image isSelf:isSelf userId:userId userName:userName time:time type:type];
    
}
//存储图片，利用userId和时间戳构成一个图片地址
-(void)_writePhoto :(UIImage *)image isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    
    NSString *douumentPath = [JH_FileManager getDocumentPath];
    NSString *dirPath = userId;
    [JH_FileManager creatDir:[NSString stringWithFormat:@"%@/%@",douumentPath,dirPath]];
    //设置一个图片的存储路径
    NSString *imagePath = [douumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.png",dirPath,time]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
    //将图片地址存入数据库
    [self _setMessageDictionary:[NSString stringWithFormat:@"/%@/%@.png",userId,time] isPath:YES isSelf:isSelf userId:userId userName:userName time:time  type:type];
    
}


//添加录音message
- (void)addAudioMediaMessage:(NSString *)path isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type{
    
    NSString *completePaht = [NSString stringWithFormat:@"%@/%@",[JH_FileManager getDocumentPath],[NSString stringWithFormat:@"%@/%@.mp3",userId,time]];
    NSData * audioData = [NSData dataWithContentsOfFile:completePaht];
        JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
        JSQMessage *audioMessage = [[JSQMessage alloc]initWithSenderId:isSelf?[UserInfoManager getUserId]:userId
                                                 senderDisplayName:isSelf?[UserInfoManager getUserName]: userName date:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]] media:audioItem];
    
    //将录音地址存入数据库
    [self _setMessageDictionary:[NSString stringWithFormat:@"/%@/%@.mp3",userId,time] isPath:YES isSelf:isSelf userId:userId userName:userName time:time  type:type];
    
    [self.messages addObject:audioMessage];
}

//添加定位信息(123/123)中间分隔为“/”
- (void)addLocationMessage:(NSString *)locationString isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type completionBlock:(JSQLocationMediaItemCompletionBlock)completion{
    //将locationString分解
    NSArray *locationArray = [locationString componentsSeparatedByString:@"/"];
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:[[locationArray firstObject]doubleValue ] longitude:[[locationArray lastObject]doubleValue ]];
    //locationItem
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [[JSQMessage alloc ]initWithSenderId:isSelf?[UserInfoManager getUserId]:userId senderDisplayName:isSelf?[UserInfoManager getUserName]: userName date:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]] media:locationItem ];

    [self.messages addObject:locationMessage];
    //存储数据库
    [self _setMessageDictionary:locationString isPath:NO isSelf:isSelf userId:userId userName:userName time:time type:MessageTypeLocation];
   
}
/**
 发送通知用于消息页面的数据更新
 */
-(void)sendNotificationForDataFresh{
    [[NSNotificationCenter defaultCenter]postNotificationName:JH_ChatMessageFreshNotification object:nil];
}
// 语音
//- (void)addAudioMediaMessage
//{
//    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"caf"];
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

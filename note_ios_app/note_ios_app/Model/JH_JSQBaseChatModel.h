//
//  JH_JSQBaseChatModel.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSQMessages.h"
#import "JH_ChatMessageHelper.h"

/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

typedef enum : NSUInteger {
    MessageTypeText,
    MessageTypePhoto,
    MessageTypeAudio,
    MessageTypeLocation
} MessageType;

@interface JH_JSQBaseChatModel : NSObject

/*
 *  这里放的都是JSQMessage对象 该对象有两个初始化方式 1.media or noMedia
 */
@property (strong, nonatomic) M_RecentMessage *baseMessages; // 已存在的message

@property (strong, nonatomic) NSMutableArray *messages; // message数组

@property (strong, nonatomic) NSDictionary *avatars; // 聊天人所有头像

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData; // 发出去的气泡颜色

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData; // 收到的气泡颜色

@property (strong, nonatomic) NSDictionary *users; // 用户名字信息

/**
 加载初始数据
 */
- (void)loadFakeMessages;
//添加图片信息
- (void)addPhotoMediaMessage:(UIImage *)image isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type;
//添加文字信息
- (void)addTextMessage:(NSString *)text isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type;


//- (void)addPhotoMediaMessage;//!< 图片消息
//
//- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion; //!< 定位小心
//
//- (void)addVideoMediaMessage; //!< 视频 无底图
//
//- (void)addVideoMediaMessageWithThumbnail; //!< 视频带底图
//
//- (void)addAudioMediaMessage; //!< 音频

@end

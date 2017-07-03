//
//  JHChatBaseViewModel.h
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ViewModelFactory.h"

#import "JHChatBaseCell.h"
#import "JH_ChatMessageHelper.h"
@interface JHChatBaseViewModel : JH_ViewModelFactory
@property(nonatomic,strong)M_RecentMessage *recentMessage;
@property(nonatomic,strong)NSMutableArray *messageList;
-(void)disSelectRowWithIndexPath:(NSIndexPath *)indexPath WithHandle:(void (^)(id result))completionBlock;
/**
 添加录音message
 */
- (void)addAudioMediaMessage:(NSString *)path isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type;
/**
 添加文字信息
 */
- (void)addTextMessage:(NSString *)text isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type;
/**
 添加定位信息(123/123)中间分隔为“/”
 */
- (void)addLocationMessage:(NSString *)locationString isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type completionBlock:(void (^)())completion;
/**
 添加图片message
 */
- (void)addPhotoMediaMessage:(UIImage *)image isSelf:(BOOL )isSelf userId:(NSString *)userId userName:(NSString *)userName time:(NSString *)time type:(MessageType )type;

@end

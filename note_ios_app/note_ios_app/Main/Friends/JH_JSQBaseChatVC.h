//
//  JH_JSQBaseChatVC.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "JH_JSQBaseChatModel.h"
@interface JH_JSQBaseChatVC : JSQMessagesViewController<JSQMessagesComposerTextViewPasteDelegate>
@property (strong, nonatomic) JH_JSQBaseChatModel *chatData; //!< 消息模型
@property (strong, nonatomic) M_RecentMessage *baseMessages; // 已存在的message
- (void)receiveMessagePressed:(UIBarButtonItem *)sender;
@end

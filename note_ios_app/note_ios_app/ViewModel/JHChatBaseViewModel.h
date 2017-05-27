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
@end

//
//  JHChatMessageViewModel.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatMessageCell.h"
#import "JHChatMessageModel.h"
#import "JH_ViewModelFactory.h"
@interface JHChatMessageViewModel : JH_ViewModelFactory
@property(nonatomic,strong)NSMutableArray *chatMessageData;
@property(nonatomic,strong)NSArray *chatMessageModelList;
@end

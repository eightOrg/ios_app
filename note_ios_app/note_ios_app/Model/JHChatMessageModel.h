//
//  JHChatMessageModel.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHChatMessageModel : NSObject
@property(nonatomic,assign)NSInteger type;//消息类型
@property(nonatomic,copy)NSString *name;//昵称
@property(nonatomic,copy)NSString *portrail;//头像
@property(nonatomic,copy)NSString *number;//未读信息数量
@property(nonatomic,copy)NSString *resentMessage;//最新信息
@property(nonatomic,copy)NSString *time;//时间
@end

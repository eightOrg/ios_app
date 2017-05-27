//
//  JHChatFriendViewModel.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatFriendCell.h"
#import "JHChatFriendSectionModel.h"
#import "JHChatFriendGroupView.h"
#import "JH_ViewModelFactory.h"
@interface JHChatFriendViewModel :JH_ViewModelFactory

/**
 获取当前位置的用户id

 @param indexPath NSIndexPath
 @return NSString
 */
-(NSString *)getUserId:(NSIndexPath *)indexPath;

/**
 获取当前位置的用户name
 
 @param indexPath NSIndexPath
 @return NSString
 */
-(NSString *)getUserName:(NSIndexPath *)indexPath;
@end

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
@interface JHChatFriendViewModel :NSObject


/**
 加载数据并给model和cell赋值

 @param resultBlock result
 */
-(void)CF_LoadData:(void(^)(id result))resultBlock;

/**
 将行数放回给VC

 @return 行数
 */
-(NSInteger)CF_numberOfSection;
/**
 将列数放回给VC
 
 @param section 行数
 @return 列数
 */
-(NSInteger)CF_numberOfRow:(NSInteger)section;

/**
 直接放回cell给VC

 @param indexPath indexPath
 @return cell
 */
-(JHChatFriendCell *)setUpTableViewCell:(NSIndexPath *)indexPath;

/**
 根据组创建头视图

 @param section 组数
 @return JHChatFriendGroupView
 */
-(JHChatFriendGroupView *)_creatJHChatFriendGroupView:(NSInteger )section;
@end

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
@interface JHChatMessageViewModel : NSObject
/**
 加载数据并给model和cell赋值
 
 @param resultBlock result
 */
-(void)CF_LoadData:(void(^)(id result))resultBlock;

/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)CF_numberOfRow;

/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(JHChatMessageCell *)setUpTableViewCell:(NSIndexPath *)indexPath;

@end

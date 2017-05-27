//
//  JHChatBaseCell.h
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JH_ChatMessageHelper.h"
#import "JHChatBaseCellText.h"
#import "JHChatBaseCellVoice.h"
#import "JHChatBaseCellImage.h"
#import "JHChatBaseCellLocation.h"

@interface JHChatBaseCell : UITableViewCell
//创建视图
+(UITableViewCell *)cellWithTableView:(UITableView *)tableView messageModel:(M_MessageList *)model;
//获取高度
+(CGFloat)tableHeightWithModel:(M_MessageList *)model;
@end

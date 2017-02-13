//
//  JHChatFriendCell.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatFriendItem.h"
@interface JHChatFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrail;
@property (weak, nonatomic) IBOutlet UILabel *labNickName;
@property (weak, nonatomic) IBOutlet UILabel *labPoint;

/**
 设置cell的内容，通过item这个适配器（相当于适配器模式）

 @param item JHChatFriendItem
 */
-(void)_setChatFriendModel:(JHChatFriendItem *)item;
@end

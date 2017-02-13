//
//  JHChatFriendCell.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatFriendCell.h"

@implementation JHChatFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 设置cell的内容，通过item这个适配器（相当于适配器模式）
 
 @param item JHChatFriendItem
 */
-(void)_setChatFriendModel:(JHChatFriendItem *)item{
    self.labNickName.text = item.name;
    self.labPoint.text = item.point;
//    self.imgPortrail
}

@end

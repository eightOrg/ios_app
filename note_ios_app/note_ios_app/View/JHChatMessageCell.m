//
//  JHChatMessageCell.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatMessageCell.h"
#import "JH_ChatMessageHelper.h"
@implementation JHChatMessageCell

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
 
 @param item JHChatMessageItem
 */
-(void)_setChatMessageModel:(JHChatMessageItem *)item{
    self.labName.text = item.name;
    self.labTime.text = item.time;
    self.labNumber.text = [item.number isEqualToString:@"0"]?@"":item.number;
    switch (item.type) {
        case MessageTypeText:
                self.labMessage.text = item.resentMessage;
            break;
        case MessageTypeVoice:
            self.labMessage.text = @"[语音信息]";
            break;
        case MessageTypeImage:
            self.labMessage.text = @"[图片信息]";
            break;
        case MessageTypeLocation:
            self.labMessage.text = @"[位置信息]";
            break;
            
        default:
            break;
    }
    
}
@end

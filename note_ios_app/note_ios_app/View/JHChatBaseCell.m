//
//  JHChatBaseCell.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCell.h"

@implementation JHChatBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
/**
 创建cell
 */
+(UITableViewCell *)cellWithTableView:(UITableView *)tableView messageModel:(M_MessageList *)model{
    
    
    
    if (model.message_type == MessageTypeText) {
        static NSString *identifier = @"JHChatBaseCellText";
        JHChatBaseCellText *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellText alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        return cell;
    }else if (model.message_type == MessageTypeVoice) {
        static NSString *identifier = @"JHChatBaseCellVoice";
        JHChatBaseCellVoice *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellVoice alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        return cell;
    }else if (model.message_type == MessageTypeImage) {
        static NSString *identifier = @"JHChatBaseCellImage";
        JHChatBaseCellImage *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellImage alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        return cell;
    }else if (model.message_type == MessageTypeLocation){
        static NSString *identifier = @"JHChatBaseCellLocation";
        JHChatBaseCellLocation *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellLocation alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        return cell;
    }

    return nil;

}
+(CGFloat)tableHeightWithModel:(M_MessageList *)model{
    
    if (model.message_type == MessageTypeText) {
        return 40;
    }else if (model.message_type == MessageTypeVoice) {
        return 50;
    }else if (model.message_type == MessageTypeImage) {
        return 150;
    }else if (model.message_type == MessageTypeLocation){
        return 100;
    }
    return 50;
}

@end

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
+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(M_MessageList *)model{
    
    static NSString *identifier = @"JHChatBaseCell";
    
    JHChatBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[JHChatBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    return cell;

}
+(CGFloat)tableHeightWithModel:(M_MessageList *)model{
    
    
    return 100;
}

@end

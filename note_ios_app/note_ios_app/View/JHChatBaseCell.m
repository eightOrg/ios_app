//
//  JHChatBaseCell.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCell.h"

@implementation JHChatBaseCell
#define LEFT_WITH (JHSCREENWIDTH>750?55:52.5)
#define RIGHT_WITH (JHSCREENWIDTH>750?89:73)
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
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.messageModel = model;
        return cell;
    }else if (model.message_type == MessageTypeVoice) {
        static NSString *identifier = @"JHChatBaseCellVoice";
        JHChatBaseCellVoice *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellVoice alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        return cell;
    }else if (model.message_type == MessageTypeImage) {
        static NSString *identifier = @"JHChatBaseCellImage";
        JHChatBaseCellImage *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellImage alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        return cell;
    }else if (model.message_type == MessageTypeLocation){
        static NSString *identifier = @"JHChatBaseCellLocation";
        JHChatBaseCellLocation *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[JHChatBaseCellLocation alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.messageModel = model;
        return cell;
    }
    
    return nil;
    
}
+(CGFloat)tableHeightWithModel:(M_MessageList *)model{
    CGFloat masTop=10;
    
    if (model.message_isShowTime) {
        
        masTop=37;
        
    }
    if (model.message_type==MessageTypeText) {
        
        
        CGFloat maxWith=JHSCREENWIDTH-LEFT_WITH-RIGHT_WITH-14-12-4;
        
        
        UIFont *textFont=[UIFont systemFontOfSize:14];
        
        
        NSDictionary *attributes = @{NSFontAttributeName: textFont};
        
        CGRect rect = [model.message_text boundingRectWithSize:CGSizeMake(maxWith, MAXFLOAT)
                       
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                       
                                                    attributes:attributes
                       
                                                       context:nil];
        
        
        
        
        
        
        return rect.size.height+26+masTop+20;
        
    }else if (model.message_type == MessageTypeVoice) {
        return 50;
    }else if (model.message_type == MessageTypeImage) {
        return 150;
    }else if (model.message_type == MessageTypeLocation){
        return JHSCREENWIDTH/2*2/3+26+masTop+20;
    }
    return 50;
}

@end

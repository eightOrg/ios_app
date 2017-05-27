//
//  JHChatBaseCellLocation.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCellLocation.h"

@implementation JHChatBaseCellLocation

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

-(void)setMessageModel:(M_MessageList *)messageModel{
    if (_messageModel!=messageModel) {
        _messageModel = messageModel;
    }
    
}

@end

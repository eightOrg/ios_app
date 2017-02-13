//
//  JHChatMessageCell.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatMessageItem.h"
@interface JHChatMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrail;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labMessage;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labNumber;

/**
 设置cell的内容，通过item这个适配器（相当于适配器模式）
 
 @param item JHChatMessageItem
 */
-(void)_setChatMessageModel:(JHChatMessageItem *)item;
@end

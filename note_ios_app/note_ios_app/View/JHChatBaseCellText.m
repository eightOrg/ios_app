//
//  JHChatBaseCellText.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCellText.h"
#define LEFT_WITH (JHSCREENWIDTH>750?55:52.5)
#define RIGHT_WITH (JHSCREENWIDTH>750?89:73)
@implementation JHChatBaseCellText

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)setMessageModel:(M_MessageList *)messageModel{
    if (_messageModel!=messageModel) {
        _messageModel = messageModel;
    }
    [self creatSubViews];
}

-(void)creatSubViews{
    // 是发送还是接受
    CGFloat masTop=10;
    
    if (_messageModel.message_isShowTime) {
        
        masTop=37;
        
        UILabel *timeLabel=[[UILabel alloc] init];
        timeLabel.font=[UIFont fontWithName:FONT_REGULAR size:10];
        timeLabel.backgroundColor=COLOR_cecece;
        timeLabel.textColor=COLOR_ffffff;
        timeLabel.text= [NSString changeTimeIntervalToMinute:@(_messageModel.message_time)];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.layer.masksToBounds=YES;
        timeLabel.layer.cornerRadius=4;
        timeLabel.layer.borderColor=[COLOR_cecece CGColor];
        timeLabel.layer.borderWidth=1;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(17);
        }];
        
    }

    UIImageView *contextBack=[[UIImageView alloc] init];
    contextBack.userInteractionEnabled=YES;
    


    if (_messageModel.message_isSelf==MessageSenderTypeReceived) {
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(10, masTop, 40, 40);
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        
        
        CGFloat maxWith=JHSCREENWIDTH-LEFT_WITH-RIGHT_WITH-14-12-4;
        
        UIFont *textFont=[UIFont fontWithName:FONT_REGULAR size:16];
        
        
        NSDictionary *attributes = @{NSFontAttributeName: textFont};
        
        CGRect rect = [_messageModel.message_text boundingRectWithSize:CGSizeMake(maxWith, MAXFLOAT)
                       
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                       
                                                            attributes:attributes
                       
                                                               context:nil];
        contextBack.frame=CGRectMake(LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback1"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        [self.contentView addSubview:contextBack];

        UILabel *textMessageLabel=[[UILabel alloc] init];
        textMessageLabel.frame=CGRectMake(LEFT_WITH+12, masTop+14, rect.size.width, rect.size.height);
        textMessageLabel.numberOfLines=0;
        textMessageLabel.lineBreakMode=NSLineBreakByWordWrapping;
        textMessageLabel.font=textFont;
        textMessageLabel.textColor=COLOR_444444;
        textMessageLabel.text=_messageModel.message_text;
        [self.contentView addSubview:textMessageLabel];
        
   
    }else if (_messageModel.message_isSelf==MessageSenderTypeSend) {
        
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(JHSCREENWIDTH-10-40, masTop, 40, 40);
//        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        CGFloat maxWith=JHSCREENWIDTH-LEFT_WITH-RIGHT_WITH-14-12-4;
        UIFont *textFont=[UIFont fontWithName:FONT_REGULAR size:16];
        NSDictionary *attributes = @{NSFontAttributeName: textFont};
        CGRect rect = [_messageModel.message_text boundingRectWithSize:CGSizeMake(maxWith, MAXFLOAT)
                       
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                       
                                                   attributes:attributes
                       
                                                      context:nil];
        
        
        
        
        
        
        
        contextBack.frame=CGRectMake(JHSCREENWIDTH-(rect.size.width+26)-LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback2"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        [self.contentView addSubview:contextBack];
        
        
        
        
        UILabel *textMessageLabel=[[UILabel alloc] init];
        textMessageLabel.frame=CGRectMake(JHSCREENWIDTH-(rect.size.width+26)-LEFT_WITH+12, masTop+14, rect.size.width, rect.size.height);
        textMessageLabel.numberOfLines=0;
        textMessageLabel.lineBreakMode=NSLineBreakByWordWrapping;
        textMessageLabel.font=textFont;
        textMessageLabel.textColor=COLOR_444444;
        textMessageLabel.text=_messageModel.message_text;
        [self.contentView addSubview:textMessageLabel];
        
    }
    
    
}
@end

//
//  JHChatBaseCellImage.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCellImage.h"

@implementation JHChatBaseCellImage

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor orangeColor];
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
        timeLabel.font=[UIFont systemFontOfSize:10];
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
    CGRect rect =  CGRectMake(0, 0, JHSCREENWIDTH/2,JHSCREENWIDTH/2);
    //根据路径获取图片
    //获取图片
    NSString *documentPath = [JH_FileManager getDocumentPath];
    NSString *imagePath = _messageModel.message_path;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",documentPath,imagePath]];
    
    if (_messageModel.message_isSelf==MessageSenderTypeReceived) {
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(10, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic_r@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        contextBack.frame=CGRectMake(LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback1"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
//        [self.contentView addSubview:contextBack];
        
        //地图图片
        UIImageView *mapImage = [[UIImageView alloc] initWithFrame:contextBack.frame];
        mapImage.image = image;
        mapImage.contentMode = UIViewContentModeScaleAspectFit;;
        [self.contentView addSubview:mapImage];
        
    }else if (_messageModel.message_isSelf==MessageSenderTypeSend) {
        
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(JHSCREENWIDTH-10-40, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        contextBack.frame=CGRectMake(JHSCREENWIDTH-(rect.size.width+26)-LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback2"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
//        [self.contentView addSubview:contextBack];
        

        //地图图片
        UIImageView *mapImage = [[UIImageView alloc] initWithFrame:contextBack.frame];
        mapImage.contentMode = UIViewContentModeScaleAspectFit;
        mapImage.image = image;
        [self.contentView addSubview:mapImage];
    }
}
@end

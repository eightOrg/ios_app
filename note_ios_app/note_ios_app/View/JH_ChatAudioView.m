//
//  JH_ChatAudioView.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ChatAudioView.h"

@implementation JH_ChatAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSubView];
    }
    return self;
}

/**
 懒加载
 */

-(UILabel *)audioTimeLabel{
    if (_audioTimeLabel==nil) {
        _audioTimeLabel               = [[ThemeLabel alloc]initWithFrame:CGRectMake(JHSCREENWIDTH/2-30, 0, 60, 30)];
        _audioTimeLabel.font          = [UIFont systemFontOfSize:12];
        _audioTimeLabel.textAlignment = NSTextAlignmentCenter;
        _audioTimeLabel.text          = @"00:00";
        
        
    }
    return _audioTimeLabel;
}
-(UIImageView *)audioImage{
    if (_audioImage==nil) {
        _audioImage = [[UIImageView alloc]initWithFrame:CGRectMake(JHSCREENWIDTH/2-30-30,0 , 30, 30)];
        _audioImage.image = JHUIIMAGE(@"录音条3(1)");
        
    }
    return _audioImage;
}
/**
 创建一个语音图标和时间label
 */
-(void)_creatSubView{
    [self addSubview:self.audioTimeLabel];
    [self addSubview:self.audioImage];
}

@end

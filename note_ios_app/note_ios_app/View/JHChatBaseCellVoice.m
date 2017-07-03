//
//  JHChatBaseCellVoice.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCellVoice.h"

@implementation JHChatBaseCellVoice

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor blueColor];
    }
    return self;
}
-(void)setMessageModel:(M_MessageList *)messageModel{
    if (_messageModel!=messageModel) {
        _messageModel = messageModel;
    }
    [self _creatVoicePlayView];
}

/**
 创建播放视图
 */
-(void)_creatVoicePlayView{
    //获取文件路劲
    NSString *completePaht = [NSString stringWithFormat:@"%@%@",[JH_FileManager getDocumentPath],_messageModel.message_path];
    NSData * audioData = [NSData dataWithContentsOfFile:completePaht];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
    self.audioPlayer.delegate = self;
    //需要播放按钮和进度条
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

    CGRect rect =  CGRectMake(0, 0, JHSCREENWIDTH/2,25);
    
    if (_messageModel.message_isSelf==MessageSenderTypeReceived) {
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(10, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic_r@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        contextBack.frame=CGRectMake(LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback1"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        [self.contentView addSubview:contextBack];
        
        
    }else if (_messageModel.message_isSelf==MessageSenderTypeSend) {
        
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(JHSCREENWIDTH-10-40, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        contextBack.frame=CGRectMake(JHSCREENWIDTH-(rect.size.width+26)-LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback2"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        [self.contentView addSubview:contextBack];
        
    }
    //添加播放按钮
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 25, 25)];
    [_playButton addTarget:self action:@selector(onPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _playButton.center = CGPointMake(_playButton.center.x, contextBack.height/2);
    [contextBack addSubview:_playButton];
    
    //添加进度条
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.tintColor = BaseColor;
    _progressView.frame = CGRectMake(50, 0, contextBack.frame.size.width-100, 20);
    _progressView.center = CGPointMake(_progressView.center.x, _playButton.center.y);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _progressView.layer.cornerRadius = 2.0;
    _progressView.layer.masksToBounds = YES;
    _progressView.transform = transform;//设定宽高
    [contextBack addSubview:_progressView];
    
    //添加时间
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(contextBack.frame.size.width-50, 0, 50, 20)];
    _progressLabel.text = [self timestampString:self.audioPlayer.duration
                                    forDuration:self.audioPlayer.duration];
    _progressLabel.font = [UIFont systemFontOfSize:12];
    _progressLabel.textColor = [UIColor lightGrayColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.center = CGPointMake(_progressLabel.center.x, _playButton.center.y);
    
    [contextBack addSubview:_progressLabel];
    
}

/**
 启动定时器
 */
- (void)startProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(updateProgressTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
}

/**
 停止定时器
 */
- (void)stopProgressTimer
{
    [_progressTimer invalidate];
    _progressTimer = nil;
}

/**
 定时器执行的动作

 @param sender NSTimer
 */
- (void)updateProgressTimer:(NSTimer *)sender
{
    if (self.audioPlayer.playing) {
        self.progressView.progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
        self.progressLabel.text = [self timestampString:self.audioPlayer.currentTime
                                            forDuration:self.audioPlayer.duration];
    }
}

/**
 根据时间转换成展示的分秒

 @param currentTime 播放器当前时间
 @param duration 音乐总时长
 @return 显示文本
 */
- (NSString *)timestampString:(NSTimeInterval)currentTime forDuration:(NSTimeInterval)duration
{
    // print the time as 0:ss or ss.x up to 59 seconds
    // print the time as m:ss up to 59:59 seconds
    // print the time as h:mm:ss for anything longer
    if (duration < 60) {
        if (currentTime < duration) {
            return [NSString stringWithFormat:@"0:%02d", (int)round(currentTime)];
        }
        return [NSString stringWithFormat:@"0:%02d", (int)ceil(currentTime)];
    }
    else if (duration < 3600) {
        return [NSString stringWithFormat:@"%d:%02d", (int)currentTime / 60, (int)currentTime % 60];
    }
    
    return [NSString stringWithFormat:@"%d:%02d:%02d", (int)currentTime / 3600, (int)currentTime / 60, (int)currentTime % 60];
}
/**
 播放和暂停
 */
- (void)onPlayButton:(UIButton *)sender
{
//    NSString *category = [AVAudioSession sharedInstance].category;
//    AVAudioSessionCategoryOptions options = [AVAudioSession sharedInstance].categoryOptions;
//    
    if (self.audioPlayer.playing) {
        self.playButton.selected = NO;
        [self stopProgressTimer];
        [self.audioPlayer stop];
    }
    else {
        // fade the button from play to pause
        [UIView transitionWithView:self.playButton
                          duration:.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.playButton.selected = YES;
                        }
                        completion:nil];
        
        [self startProgressTimer];
        [self.audioPlayer play];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    
    // set progress to full, then fade back to the default state
    [self stopProgressTimer];
    self.progressView.progress = 1;
    [UIView animateWithDuration:1 animations:^{
        self.progressView.progress = 0;
    } completion:^(BOOL finished) {
        self.playButton.selected = NO;
        self.progressLabel.text = [self timestampString:self.audioPlayer.duration
                                            forDuration:self.audioPlayer.duration];
    }];
    
    
    
}
@end

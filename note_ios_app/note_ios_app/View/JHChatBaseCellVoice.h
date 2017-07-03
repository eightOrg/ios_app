//
//  JHChatBaseCellVoice.h
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "JH_ChatMessageHelper.h"
@interface JHChatBaseCellVoice : UITableViewCell<AVAudioPlayerDelegate>
@property(nonatomic,strong) M_MessageList *messageModel;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer; //播放
@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) UIView *cachedMediaView;
@end

//
//  JHChatVoiceView.h
//  note_ios_app
//
//  Created by hyjt on 2017/6/30.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, RecordStatus) {
    RecordStatusCancel=0,
    RecordStatusReady,
    RecordStatusStart,
    RecordStatusStop,
    RecordStatusSend
};
/**
 录音取消和发送的按钮回调
 */
typedef void(^JHChatVoiceViewBlock)(RecordStatus status);

@interface JHChatVoiceView : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgVoice;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property(nonatomic,copy)JHChatVoiceViewBlock block;
@property(nonatomic,assign)RecordStatus status;
@property (nonatomic,strong) NSTimer *timer;  //控制录音时长显示更新
@property (nonatomic,assign) NSInteger countNum;//录音计时（秒）
@end

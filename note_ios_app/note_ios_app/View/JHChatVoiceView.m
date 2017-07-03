//
//  JHChatVoiceView.m
//  note_ios_app
//
//  Created by hyjt on 2017/6/30.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatVoiceView.h"

@implementation JHChatVoiceView

-(void)awakeFromNib{
    [super awakeFromNib];
    //设置一些属性
    self.status=RecordStatusReady;
    self.sendButton.enabled = NO;
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:0];
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    _block(RecordStatusCancel);
}

- (IBAction)sendAction:(UIButton *)sender {
    _block(RecordStatusSend);
    
}
- (IBAction)recordAction:(UIButton *)sender {
    if (self.status==RecordStatusReady) {
        self.status = RecordStatusStart;
        [self.btnRecord setImage:[UIImage imageNamed:@"正在录音"] forState:0];
        _block(RecordStatusStart);
        //开启定时器
        self.countNum = 0;
        NSTimeInterval timeInterval =1 ; //0.1s
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval  target:self selector:@selector(changeRecordTime)  userInfo:nil  repeats:YES];
        
        [self.timer fire];
        
    }else if (self.status==RecordStatusStart){
        self.status = RecordStatusStop;
        [self.btnRecord setImage:[UIImage imageNamed:@"暂停录音"] forState:0];
        [self.sendButton setTitleColor:BaseColor forState:0];
        self.sendButton.enabled = YES;
        //停止定时器
        [self.timer invalidate];
        _block(RecordStatusStop);
    }
}
//时间改变
- (void)changeRecordTime
{
    
    self.countNum += 1;
    NSInteger min = self.countNum/60;
    NSInteger sec = self.countNum - min * 60;
    
    self.labTime.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}



@end

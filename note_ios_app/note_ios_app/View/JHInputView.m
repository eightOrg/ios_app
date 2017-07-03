//
//  JHInputView.m
//  note_ios_app
//
//  Created by hyjt on 2017/6/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHInputView.h"
#import "JHMapLocationVC.h"
#import "JHChatVoiceBaseView.h"
#import <AVFoundation/AVFoundation.h>
//音频格式转换
#import "lame.h"
@interface JHInputView()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,copy) NSString *cafPathStr;
@property (nonatomic,copy) NSString *mp3PathStr;
@end
@implementation JHInputView

#pragma mark - system (systemMethod override)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBaseBGColor;
        [self _creatSubViews];
    }
    return self;
}
-(void)layoutSubviews{
    [self layoutAll];
}
#pragma mark - UI (creatSubView and layout)
-(void)_creatSubViews{
    CGFloat buttonInset = 10;
    CGFloat buttonViewHeight = 50;
    CGFloat space = (self.frame.size.width-(buttonViewHeight-buttonInset*2)*4)/5;
    //四个按钮
    _buttonView =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-buttonViewHeight,self.frame.size.width, buttonViewHeight)];
    [self addSubview:_buttonView];
    for (int i = 0; i<[self buttonImages].count; i++) {
        NSString *imageName = [self buttonImages][i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(space*(i+1)+(buttonViewHeight-buttonInset*2)*i, buttonInset, buttonViewHeight-buttonInset*2, buttonViewHeight-buttonInset*2)];
        button.tag = i;
        [button addTarget:self action:@selector(_additionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:button];
        [button setImage:[UIImage imageNamed:imageName] forState:0];
    }
    
    [self addSubview:self.sendButton];
    [self addSubview:self.textView];
    [self layoutAll];
    
    
    
}
-(void)layoutAll{
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.bottom.equalTo(_buttonView.mas_top).with.offset(0);
    }];
    
    //插入输入框
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self.sendButton.mas_left).with.offset(-10);
        make.top.equalTo(self).with.offset(5);
        make.bottom.equalTo(_buttonView.mas_top);
    }];
    
    
}
/**
 懒加载
 */
-(UITextView *)textView{
    if (!_textView) {
        _textView = ({
            UITextView *text = [UITextView new];
            text.font = [UIFont systemFontOfSize:16];
            text.delegate = self;
            text.layer.cornerRadius = 5;
            text;
        });
    }
    return _textView;
}
-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = ({
            UIButton *button = [UIButton new];
            [button setTitle:@"发送" forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:0];
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(_sendAction) forControlEvents:UIControlEventTouchUpInside];
             button;
        });
    }
    return _sendButton;
}

#pragma mark - delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        [self.sendButton setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        [self.sendButton setBackgroundColor:BaseColor];
    }
}

#pragma mark - utilMethod

/**
 四个附加信息
 */
-(void)_additionButtonAction:(UIButton *)btn{
    //录音，相册，拍照，定位
    switch (btn.tag) {
        case 0:
            [self _showRecordView];
            break;
        case 1:
            [self _openLibrary];
            break;
        case 2:
            [self _openCamaro];
            break;
        case 3:
        {
            JHMapLocationVC *location = [[JHMapLocationVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:location];
            [self.viewController.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
            WeakSelf
            [location setLocationBlock:^(double latitude, double longitude){
                if ([weakSelf.sendDelegate respondsToSelector:@selector(JHsendMessageWithLocationWithLatitude:withlongitude:)]) {
                    [weakSelf.sendDelegate JHsendMessageWithLocationWithLatitude:latitude withlongitude:longitude];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}

/**
 创建录音视图
 */
-(void)_showRecordView{
    UIView *selfView = self.viewController.view;
    [selfView endEditing:YES];
    JHChatVoiceBaseView *voice = [[JHChatVoiceBaseView alloc] initWithFrame:selfView.bounds];
    [selfView addSubview:voice];
    WeakSelf
    [voice setBlock:^(RecordStatus status){
        switch (status) {
            case RecordStatusCancel:
                [weakSelf stopRecordNoticeWithCancel:YES];
                break;
            case RecordStatusStart:
                [weakSelf startRecordNotice];
                break;
            case RecordStatusStop:
                [weakSelf stopRecordNoticeWithCancel:NO];
                break;
            case RecordStatusSend:
                [weakSelf _sendAudio];
                break;
            default:
                break;
        }
    }];
    
}
/**
 发送
 */
-(void)_sendAction{
    if (self.textView.text.length==0) {
        return;
    }else{
        if ([self.sendDelegate respondsToSelector:@selector(JHsendMessageWithText:)]) {
            [self.sendDelegate JHsendMessageWithText:self.textView.text];
            self.textView.text = @"";
        }
        
    }
}

/**
 打开相机
 */
-(void)_openCamaro{
    [self _getImageDatafromLibraryOrCamera:UIImagePickerControllerSourceTypeCamera];
}
/**
 打开相册
 */
-(void)_openLibrary{
    [self _getImageDatafromLibraryOrCamera:UIImagePickerControllerSourceTypePhotoLibrary];
}

/**
 从相册中获取相片
 */
-(void)_getImageDatafromLibraryOrCamera:(UIImagePickerControllerSourceType )sourceType{
    
    //相册资源
    UIImagePickerControllerSourceType type = sourceType;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    //开启编辑
    //    _picker.allowsEditing = YES;
    picker.sourceType    = type;
    if ([self.sendDelegate respondsToSelector:@selector(JHsendMessageWithImage:)]) {
        [self.sendDelegate JHsendMessageWithImage:picker];
    }
    
}

/**
 发送录音
 */
-(void)_sendAudio{
    //发送录音文件
    if ([self.sendDelegate respondsToSelector:@selector(JHsendMessageWithAudioDir:)]) {
        [self.sendDelegate JHsendMessageWithAudioDir:self.mp3PathStr];
    }
}
/**
 获取录音文件的完整路径
 
 @return NSString
 */
-(NSString *)getCafCompletePath{
    //设置存储路径
    NSString *douumentPath = [JH_FileManager getDocumentPath];
    NSString *dirPath = self.userId;
    [JH_FileManager creatDir:[NSString stringWithFormat:@"%@/%@",douumentPath,dirPath]];
    //设置一个图片的存储路径
    NSString *completePath = [douumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.caf",dirPath,self.cafPathStr]];
    return  completePath;
    
}
/**
 获取mp3文件的完整路径
 
 @return NSString
 */
-(NSString *)getMp3CompletePath{
    //设置存储路径
    NSString *douumentPath = [JH_FileManager getDocumentPath];
    NSString *dirPath = self.userId;
    [JH_FileManager creatDir:[NSString stringWithFormat:@"%@/%@",douumentPath,dirPath]];
    //设置一个图片的存储路径
    NSString *completePath = [douumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.mp3",dirPath,self.mp3PathStr]];
    return  completePath;
    
}


#pragma mark - 录音方法
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[NSURL URLWithString:[self getCafCompletePath]];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return recordSettings;
}

/**
 开始录音
 */
- (void)startRecordNotice{
    
    self.cafPathStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    self.mp3PathStr = self.cafPathStr;
    //    [self stopMusicWithUrl:[NSURL URLWithString:self.cafPathStr]];
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    NSLog(@"----------开始录音----------");
    //    [self deleteOldRecordFile];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    if (![self.audioRecorder isRecording]) {//0--停止、暂停，1-录制中
        
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    
    }
}



/**
 录音停止
 */
- (void)stopRecordNoticeWithCancel:(BOOL)isCancel;
{
    NSLog(@"----------结束录音----------");
    [self.audioRecorder stop];
    if (isCancel) {
        //删除原始录音文件
        [JH_FileManager deleteFile:[self getCafCompletePath]];
        //删除Mp3文件
        [JH_FileManager deleteFile:[self getMp3CompletePath]];
    }else{
        //由于caf格式是_audioRecorder创建的时候必须的格式，然后caf无法在其他播放，所以改下文件格式到通用的mp3

            //转换音乐
            [self audio_PCMtoMP3];
            //转换完成删除原始录音文件
            [JH_FileManager deleteFile:[self getCafCompletePath]];
        //由于audio关联路径需要先移除audio
        self.audioRecorder = nil;
    }
    
    
}

#pragma mark - caf转mp3
- (void)audio_PCMtoMP3
{
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([[self getCafCompletePath] cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([[self getMp3CompletePath] cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",[self getMp3CompletePath]);
    }
    
}



-(NSArray *)buttonImages{
    return @[
             @"录音",
             @"相册",
             @"相机",
             @"位置"
             ];
}
@end

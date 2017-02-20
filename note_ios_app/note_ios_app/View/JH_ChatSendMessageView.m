//
//  JH_ChatSendMessageView.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ChatSendMessageView.h"
#import "JH_ChatAudioView.h"

#import "lame.h"
@interface JH_ChatSendMessageView()<AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)JH_ChatAudioView *audioView;
@property(nonatomic,strong)UIView *audioButtonView;
@property (nonatomic,strong) NSTimer *timer1;  //控制录音时长显示更新
@property (nonatomic,assign) NSInteger countNum;//录音计时（秒）
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,copy) NSString *cafPathStr;
@property (nonatomic,copy) NSString *mp3PathStr;
@end

@implementation JH_ChatSendMessageView
{
    UIWindow *_sheetWindow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+100, frame.size.width, frame.size.height)];
    
    if (self) {
        [self _creatSubViews];
        [self _creatWindows];
    }
    return self;
}
-(void)_creatWindows{
    //遮罩视图
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, JHSCREENHEIGHT)];
    
    window.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.4f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWindowAction)];
    [window addGestureRecognizer:tap];
    
    window.hidden = NO;
    window.alpha = 0;
    _sheetWindow = window;
    [UIView animateWithDuration:JH_UIViewAnimation delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-100, self.frame.size.width, self.frame.size.height);
        self.alpha = 1;
        _sheetWindow.frame = CGRectMake(0, -JHSCREENWIDTH/4, JHSCREENWIDTH, JHSCREENHEIGHT);
        _sheetWindow.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}
/**
 *  移除视图并回调参数
 */
-(void)removeWindowAction{
    
    
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
        _sheetWindow.frame = CGRectMake(0,0, JHSCREENWIDTH, JHSCREENHEIGHT);
        _sheetWindow.alpha = 0;
    }completion:^(BOOL finished) {
        
        _sheetWindow.hidden = YES;
        _sheetWindow=nil;
        [self removeFromSuperview];
    }];
}

/**
 *  从xib中添加的
 */
-(void)awakeFromNib{
    [super awakeFromNib];
    //线程延迟，达到先获取父视图大小再子视图作用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self _creatSubViews];
    });
}
/**
 *  创建分享的子视图
 */
-(void)_creatSubViews{
    //    分享共两个按钮
    //按钮图片来源
    NSArray *imageNames = @[@"录音",@"相机",@"相册",@"位置"];
    NSArray *labelNames = @[@"录音",@"相机",@"相册",@"位置"];
    
    //    设置间隙
    CGFloat space = self.frame.size.width/4/4;
    //    设置大小
    CGFloat width = space*2;
    
    for (int i = 0; i<imageNames.count; i++) {
        //创建按钮
        UIButton *button = [UIButton new];
        [self addSubview:button];
        [button setImage:JHUIIMAGE(imageNames[i]) forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(space+width*2*(i), space, width, width);
        
        //创建标签
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text = labelNames[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.frame = CGRectMake(width*2*(i), space*3, width*2,space);
        
        [self addSubview:label];

    }
    
}
/**
 *  按钮点击分享
 *
 *  @param btn 分享的不同动作
 */
-(void)buttonAction:(UIButton *)btn{
//    @"录音",@"相机",@"相册",@"位置"
    switch (btn.tag) {
        case 100:
            [self _creatLongPressBaseView];
            return;
            break;
        case 101:
            [self getOCRDatafromLibraryOrCamera:UIImagePickerControllerSourceTypeCamera];
            break;
        case 102:
            [self getOCRDatafromLibraryOrCamera:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 103:
            
            break;
        default:
            break;
    }
    [self removeWindowAction];
}

/**
 用于长按录制的视图（长按按钮、关闭按钮）
 */
-(void)_creatLongPressBaseView{
    //基础视图
    _audioButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _audioButtonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_audioButtonView];
    
    //长按按钮
    UIButton *btnPress = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioButtonView addSubview:btnPress];
    [btnPress setTitle:@"长按 说话" forState:0];
    btnPress.showsTouchWhenHighlighted = YES;
    [btnPress setTitleColor:[UIColor lightGrayColor] forState:0];
    btnPress.frame = CGRectMake(20, 0, self.frame.size.width-self.frame.size.height, 50);
    btnPress.center = CGPointMake(btnPress.center.x, self.frame.size.height/2);
    btnPress.layer.cornerRadius = 5;
    btnPress.layer.borderWidth = 1;
    btnPress.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //实例化长按手势监听
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    [btnPress addGestureRecognizer:longPress];

    //关闭按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btnClose setImage:JHUIIMAGE(@"关闭") forState:0];
    btnClose.center = CGPointMake(self.frame.size.width-self.frame.size.height/2+10, self.frame.size.height/2);
    [btnClose addTarget:self action:@selector(_closeAudioAction) forControlEvents:UIControlEventTouchUpInside];
    [_audioButtonView addSubview:btnClose];
    
    
}

/**
 关闭录音长按按钮
 */
-(void)_closeAudioAction{
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
    
        _audioButtonView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [_audioButtonView removeFromSuperview];
        _audioButtonView = nil;
    }];
    
}

//长按之后的事件
-(void)longPressBeginShowView{
    {
        if (_audioView==nil) {
            //设置存储路径
            self.cafPathStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            self.mp3PathStr = self.cafPathStr;
            _audioView = [[JH_ChatAudioView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH, 30)];
            _audioView.center = self.center;
            [_sheetWindow addSubview:_audioView];
            
        }
        
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
//开始录音
//结束录音
//长按事件的实现方法

- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state ==  UIGestureRecognizerStateBegan) {
        
        NSLog(@"UIGestureRecognizerStateBegan");
        [self longPressBeginShowView];
        [self startRecordNotice];
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        [self stopRecordNotice];
        
    }
    
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
    
    
//    [self stopMusicWithUrl:[NSURL URLWithString:self.cafPathStr]];
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    NSLog(@"----------开始录音----------");
//    [self deleteOldRecordFile];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
//    [_recordBtn setImage:[UIImage imageNamed:@"record_high"]];
    
    if (![self.audioRecorder isRecording]) {//0--停止、暂停，1-录制中
        
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.countNum = 0;
        NSTimeInterval timeInterval =1 ; //0.1s
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:timeInterval  target:self selector:@selector(changeRecordTime)  userInfo:nil  repeats:YES];
        
        [self.timer1 fire];
    }
    
}
//时间改变
- (void)changeRecordTime
{
    
    self.countNum += 1;
    NSInteger min = self.countNum/60;
    NSInteger sec = self.countNum - min * 60;
    
    self.audioView.audioTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}


/**
 录音停止
 */
- (void)stopRecordNotice
{
    NSLog(@"----------结束录音----------");
    
    
    [self.audioRecorder stop];
    [self.timer1 invalidate];
    //由于caf格式是_audioRecorder创建的时候必须的格式，然后caf无法在其他播放，所以改下文件格式到通用的mp3
    //转换音乐
    [self audio_PCMtoMP3];
    //转换完成删除原始录音文件
    [JH_FileManager deleteFile:[self getCafCompletePath]];
    //代理实现位置
    if ([self.audioDelegate respondsToSelector:@selector(stopRecord:)]) {
        [self.audioDelegate stopRecord:self.mp3PathStr];
    }
    //移除视图
    [self removeWindowAction];
    
    
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

/**
 从相册中获取相片
 */
-(void)getOCRDatafromLibraryOrCamera:(UIImagePickerControllerSourceType )sourceType{
    
    //相册资源
    UIImagePickerControllerSourceType type = sourceType;
    
    _picker = [[UIImagePickerController alloc] init];
    
//    //开启编辑
//    _picker.allowsEditing = YES;
    _picker.sourceType    = type;
    if ([self.cameraDelegate respondsToSelector:@selector(setCamera:)]) {
        [self.cameraDelegate setCamera:_picker];
    }
    
}


@end

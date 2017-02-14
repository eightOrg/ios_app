//
//  JH_ChatSendMessageView.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_ChatSendMessageView.h"

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
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
    
    
    [UIView animateWithDuration:0.5 animations:^{
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
    [self removeWindowAction];
    switch (btn.tag) {
        case 100:
            
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
}
//开始录音
//打开相册
//使用相机
//发送位置
/**
 从相册中获取相片
 */
-(void)getOCRDatafromLibraryOrCamera:(UIImagePickerControllerSourceType )sourceType{
    
    //相册资源
    UIImagePickerControllerSourceType type = sourceType;
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = NO;
    _picker.sourceType    = type;
    if ([self.cameraDelegate respondsToSelector:@selector(setCamera:)]) {
        [self.cameraDelegate setCamera:_picker];
    }
    
}


@end

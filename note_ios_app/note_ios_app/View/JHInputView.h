//
//  JHInputView.h
//  note_ios_app
//
//  Created by hyjt on 2017/6/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
//用于调出系统相册和相机的代理
@protocol JH_ChatSendDelegate <NSObject>
-(void)JHsendMessageWithText:(NSString *)text;
-(void)JHsendMessageWithLocationWithLatitude:(double)latitude withlongitude:(double)longitude;
-(void)JHsendMessageWithImage:(UIImagePickerController *)picker;
@end

@interface JHInputView : UIView<UITextViewDelegate>
//输入框
@property(nonatomic,strong)UITextView *textView;
//发送按钮
@property(nonatomic,strong)UIButton *sendButton;
//四个按钮
@property(nonatomic,strong)UIView *buttonView;

@property(nonatomic,weak)id <JH_ChatSendDelegate>sendDelegate;
@end

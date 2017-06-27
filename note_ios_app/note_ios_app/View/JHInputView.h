//
//  JHInputView.h
//  note_ios_app
//
//  Created by hyjt on 2017/6/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHInputView : UIView
//输入框
@property(nonatomic,strong)UITextView *textView;
//发送按钮
@property(nonatomic,strong)UIButton *sendButton;
//四个按钮
@property(nonatomic,strong)UIView *buttonView;
@end

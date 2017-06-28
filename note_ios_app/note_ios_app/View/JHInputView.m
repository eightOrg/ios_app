//
//  JHInputView.m
//  note_ios_app
//
//  Created by hyjt on 2017/6/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHInputView.h"

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
 发送
 */
-(void)_sendAction{
    if (self.textView.text.length==0) {
        return;
    }else{
        if ([self.sendDelegate respondsToSelector:@selector(JHsendMessageWithText:)]) {
            [self.sendDelegate JHsendMessageWithText:self.textView.text];
        }
        
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

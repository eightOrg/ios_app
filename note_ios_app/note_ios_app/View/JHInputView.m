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
    CGFloat space = (self.frame.size.width-(buttonViewHeight-buttonInset)*4)/5;
    //四个按钮
    _buttonView =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-buttonViewHeight,self.frame.size.width, buttonViewHeight)];
    [self addSubview:_buttonView];
    for (int i = 0; i<[self buttonImages].count; i++) {
        NSString *imageName = [self buttonImages][i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(space*(i+1), buttonInset, buttonViewHeight-buttonInset*2, buttonViewHeight-buttonInset*2)];
        
        [_buttonView addSubview:button];
        [button setImage:[UIImage imageNamed:imageName] forState:0];
    }
    
    //发送按钮
    
    //输入框
    
    
    
    
}
-(void)layoutAll{
    
}
/**
 懒加载
 */
-(UITextView *)textView{
    if (!_textView) {
        _textView = ({
            UITextView *text = [UITextView new];
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
            [button setTitleColor:[UIColor whiteColor] forState:0];
            [button setBackgroundColor:BaseColor];
             button;
        });
    }
    return _sendButton;
}

#pragma mark - delegate
#pragma mark - utilMethod
-(NSArray *)buttonImages{
    return @[
             @"录音",
             @"相册",
             @"相机",
             @"位置"
             ];
}
@end

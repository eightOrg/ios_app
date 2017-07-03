//
//  JHChatVoiceBaseView.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/3.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatVoiceBaseView.h"

@implementation JHChatVoiceBaseView
#pragma mark - system (systemMethod override)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        self.alpha = 0;
        [self _addVoiceView];
    }
    return self;
}

#pragma mark - UI (creatSubView and layout)
-(void)_addVoiceView{
    JHChatVoiceView *voice = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JHChatVoiceView class]) owner:self options:nil]lastObject];
    [self addSubview:voice];
    WeakSelf
    [voice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(self.frame.size.height-170, 0,0, 0));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [voice setBlock:^(RecordStatus status){
        switch (status) {
            case RecordStatusCancel:
                _block(status);
                [weakSelf dismiss];
                break;
            case RecordStatusStart:
            case RecordStatusStop:
                _block(status);
                break;
            case RecordStatusSend:
                [weakSelf dismiss];
                _block(status);
                break;
            default:
                break;
        }
    }];
}

#pragma mark - delegate
#pragma mark - utilMethod
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}


@end

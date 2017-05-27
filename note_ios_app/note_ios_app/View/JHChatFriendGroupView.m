//
//  JHChatFriendGroupView.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatFriendGroupView.h"
@interface JHChatFriendGroupView()
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UILabel  *label;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,assign)BOOL isFold;
@end
@implementation JHChatFriendGroupView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withFold:(BOOL)isFold
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title  = title;
        self.isFold = isFold;
        [self _setUp];
        [self _userLayout];
    }
    return self;
}
-(UIButton *)button{
    if (_button==nil) {
        _button = [UIButton new];
        [_button setImage:JHUIIMAGE(@"三角") forState:0];
        [_button addTarget:self action:@selector(_touchAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.isFold==NO) {
            self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    return _button;
}
-(UILabel *)label{
    if (_label == nil) {
        _label      = [UILabel new];
        _label.font = [UIFont systemFontOfSize:15];
        _label.text = self.title;
        //使用手势调用和按钮点击相同的方法
        _label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_touchAction)];
        [_label addGestureRecognizer:tap];
    }
    return  _label;
}

/**
 布局实现
 */
-(void)_userLayout{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}

/**
 添加控件
 */
-(void)_setUp{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.button];
    [self addSubview:self.label];
    
}

/**
 点击事件
 */
-(void)_touchAction{
    //旋转按钮
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        if (self.isFold) {
           self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            self.button.imageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        
    }];
    //代理限制
    if ([self.delegate respondsToSelector:@selector(_setGroupFold:byIdentity:)]) {
        [self.delegate _setGroupFold:self byIdentity:self.isFold];
    }
    
}


@end

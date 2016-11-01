//
//  ThemeButton.m
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:BaseTextColor forState:0];
    }
    return self;
}

@end

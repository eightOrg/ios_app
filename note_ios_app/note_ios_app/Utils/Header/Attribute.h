//
//  Attribute.h
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#ifndef Attribute_h
#define Attribute_h

#define BaseColor [UIColor colorWithRed:28/255.f green:170/255.f blue:235/255.f alpha:1]
#define BaseTextColor [UIColor whiteColor]
#define kBaseBGColor [UIColor colorWithWhite:0.93 alpha:1]
#define JH_NavigationHeight 64
#define JH_ToolBarHeight 49
#define JHUIIMAGE(imageName) [UIImage imageNamed:imageName]
#define JHSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define JHSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define WeakSelf __weak typeof(self) weakSelf = self;
//默认动画时间
#define JH_UIViewAnimation 0.3

#endif /* Attribute_h */

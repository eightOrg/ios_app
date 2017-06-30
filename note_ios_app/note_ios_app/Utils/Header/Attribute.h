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

#define kTipAlert(_S_, ...) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] preferredStyle:UIAlertControllerStyleAlert];UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];[alertController addAction:alert];[[JH_CommonInterface presentingVC] presentViewController:alertController animated:YES completion:nil];

#define JHdispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define FONT_MEDIUM @"PingFangSC-Medium"
#define FONT_REGULAR @"PingFangSC-Regular"
#define FONT_SEMIBOLD @"PingFangSC-Semibold"
#define FONT_SC @"PingFangSC"

#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]


#define HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR_ffffff HEXRGB(0xffffff)
#define COLOR_f2f2f2 HEXRGB(0xf2f2f2)
#define COLOR_f6f6f6 HEXRGB(0xf6f6f6)
#define COLOR_a8a8a8 HEXRGB(0xa8a8a8)
#define COLOR_444444 HEXRGB(0x444444)
#define COLOR_f7f7f7 HEXRGB(0xf7f7f7)
#define COLOR_e85b53 HEXRGB(0xe85b53)
#define COLOR_666666 HEXRGB(0x666666)
#define COLOR_bababa HEXRGB(0xbababa)
#define COLOR_999999 HEXRGB(0x999999)
#define COLOR_ececec HEXRGB(0xececec)
#define COLOR_e6e6e6 HEXRGB(0xe6e6e6)
#define COLOR_4ab495 HEXRGB(0x4ab495)
#define COLOR_78879d HEXRGB(0x78879d)

#define COLOR_313232 HEXRGB(0x313232)
#define COLOR_abaaaa HEXRGB(0xabaaaa)
#define COLOR_e3e3e3 HEXRGB(0xe3e3e3)
#define COLOR_000000 HEXRGB(0x000000)
#define COLOR_cecece HEXRGB(0xcecece)
#define COLOR_2a9e39 HEXRGB(0x2a9e39)
#define COLOR_c00000 HEXRGB(0xc00000)
//默认动画时间
#define JH_UIViewAnimation 0.3
#define LEFT_WITH (JHSCREENWIDTH>750?55:52.5)
#define RIGHT_WITH (JHSCREENWIDTH>750?89:73)

#endif /* Attribute_h */

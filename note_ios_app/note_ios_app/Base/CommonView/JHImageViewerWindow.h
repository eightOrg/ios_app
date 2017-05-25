//
//  JHImageViewerWindow.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/20.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef void(^CertainBlock)(UIImage *img) ;
@interface JHImageViewerWindow : UIView
@property(nonatomic,copy)CertainBlock block;

- (instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)image;
/**
 init
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageUrl:(NSString *)imageUrl;

/**
 创建图片选择与取消的按钮
 */
-(void)_setCancelAndCertainButton;
@end

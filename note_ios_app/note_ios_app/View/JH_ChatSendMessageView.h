//
//  JH_ChatSendMessageView.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
//用于调出系统相册和相机的代理
@protocol JH_ChatCameraDelegate <NSObject>
-(void)setCamera:(UIImagePickerController *)picker;
@end

@interface JH_ChatSendMessageView : UIView
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,weak)id <JH_ChatCameraDelegate>cameraDelegate;
@end

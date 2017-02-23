//
//  JH_ChatSendMessageView.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/14.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//用于调出系统相册和相机的代理
@protocol JH_ChatCameraDelegate <NSObject>
-(void)setCamera:(UIImagePickerController *)picker;
@end
@protocol JH_ChatAudioDelegate <NSObject>
-(void)stopRecord:(NSString *)recorderPath;
@end
@protocol JH_ChatLocationDelegate <NSObject>
-(void)setLocationWith:(double)latitude longtitude:(double)longitude;
@end
@interface JH_ChatSendMessageView : UIView

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,weak)id <JH_ChatCameraDelegate>cameraDelegate;
@property(nonatomic,weak)id <JH_ChatAudioDelegate>audioDelegate;
@property(nonatomic,weak)id <JH_ChatLocationDelegate>locationDelegate;
@end

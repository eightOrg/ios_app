//
//  JH_UserLoginApi.h
//  note_ios_app
//
//  Created by 江弘 on 2016/11/9.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHBaseRequest.h"

@interface JH_UserLoginApi : JHBaseRequest
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *password;
@end

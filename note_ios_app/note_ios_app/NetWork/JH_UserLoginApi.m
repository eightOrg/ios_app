//
//  JH_UserLoginApi.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/9.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JH_UserLoginApi.h"

@implementation JH_UserLoginApi
- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@user/selectOne",BaseUrl];
}

-(id)requestArgument{
    
    return @{
             @"mobilephone" : self.mobile,
             //@"password" : self.password
             };
}
@end

//
//  JHBaseRequest.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/9.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHBaseRequest.h"

@implementation JHBaseRequest
//请求方法默认post
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}
-(NSDictionary *)requestHeaderFieldValueDictionary{
    return @{@"Dev":@"pc",
             @"session":@"690c93f2-cf87-413f-81e7-7d95889b9766"};
}
@end

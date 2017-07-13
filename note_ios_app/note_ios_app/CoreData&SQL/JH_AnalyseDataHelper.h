//
//  JH_AnalyseDataHelper.h
//  note_ios_app
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JH_ChatMessageManager.h"
#import "ViewControllerAnalyseData+CoreDataClass.h"
#import "EventAnalyseData+CoreDataClass.h"

/*
 消息类型
 */
typedef NS_ENUM(NSUInteger, AnalyseType) {
    AnalyseTypeViewController=0,
    AnalyseTypeEvent
};
@interface JH_AnalyseDataHelper : NSObject
+(void)_AnalyseWithData:(NSDictionary *)data withType:(AnalyseType )analyseType;
@end

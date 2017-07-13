//
//  JH_AnalyseDataHelper.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JH_AnalyseDataHelper.h"
#define kManagedObjectContext [JH_ChatMessageManager sharedInstance].managedObjectContext
#define JH_EventAnalyseData @"EventAnalyseData"
#define JH_ViewControllerAnalyseData @"ViewControllerAnalyseData"

@implementation JH_AnalyseDataHelper
+(void)_AnalyseWithData:(NSDictionary *)data withType:(AnalyseType )analyseType{
    if (analyseType==AnalyseTypeViewController) {
        [self analyseVCWithData:data];
    }else if (analyseType == AnalyseTypeEvent){
        [self analyseEventWithData:data];
    }
    
    
}
/**
 分析统计页面
 */
+(void)analyseVCWithData:(NSDictionary *)data{
    //判断是新建还是更新
    NSArray *list = [self _searchViewControllerData];
    //创建对应的类
    NSString *vcName = data[@"viewControllerName"];
    
    for (ViewControllerAnalyseData *vcModel in list) {
        if ([vcModel.viewControllerName isEqualToString:vcName]) {
            //更新时长数据
            vcModel.viewControllerTime = vcModel.viewControllerTime + [data[@"viewControllerTime"] floatValue];
            vcModel.viewControllerDate = data[@"viewControllerDate"];
            [[JH_ChatMessageManager sharedInstance] saveContext]; //保存
            return;
        }
    }
    //创建一个新的
    ViewControllerAnalyseData *vcModel = [NSEntityDescription insertNewObjectForEntityForName:JH_ViewControllerAnalyseData inManagedObjectContext:kManagedObjectContext];
    for (NSString *str in [data allKeys]) {
        if ([str isEqualToString:@"viewControllerTime"]) {
            float time = [data[str] floatValue];
            [vcModel setValue:@(time) forKey:str];
            continue;
        }
        [vcModel setValue:data[str] forKey:str];
    }
    
    [[JH_ChatMessageManager sharedInstance] saveContext]; //保存
}
/**
 分析统计事件
 */
+(void)analyseEventWithData:(NSDictionary *)data{
    //判断是新建还是更新
    NSArray *list = [self _searchEventData];
    //创建对应的类
    NSString *eventName = data[@"eventName"];
    
    for (EventAnalyseData *vcModel in list) {
        if ([vcModel.eventName isEqualToString:eventName]) {
            //更新点击次数数据
            vcModel.eventCount = vcModel.eventCount + [data[@"eventCount"] integerValue];
            vcModel.eventDate = data[@"eventDate"];
            [[JH_ChatMessageManager sharedInstance] saveContext]; //保存
            return;
        }
    }
    
    //创建一个新的
    EventAnalyseData *eventModel = [NSEntityDescription insertNewObjectForEntityForName:JH_EventAnalyseData inManagedObjectContext:kManagedObjectContext];
    
    for (NSString *str in [data allKeys]) {
        if ([str isEqualToString:@"eventCount"]) {
            NSInteger count = [data[str] integerValue];
            [eventModel setValue:@(count) forKey:str];
            
            continue;
        }
        [eventModel setValue:data[str] forKey:str];
    }
    
    [[JH_ChatMessageManager sharedInstance] saveContext]; //保存
}

#pragma mark - 查询数据(暂时使用全部搜索)
+(NSArray *)_searchViewControllerData{
    /**
     数据查询数据（全部）
     */
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:JH_ViewControllerAnalyseData
                                   
                                              inManagedObjectContext:kManagedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *objectResults = [kManagedObjectContext
                              
                              executeFetchRequest:request
                              
                              error:&error];
    return objectResults;
    
}
+(NSArray *)_searchEventData{
    /**
     数据查询数据（全部）
     */
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:JH_EventAnalyseData
                                   
                                              inManagedObjectContext:kManagedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *objectResults = [kManagedObjectContext
                              
                              executeFetchRequest:request
                              
                              error:&error];
    return objectResults;
    
}
@end

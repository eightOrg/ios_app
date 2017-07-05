//
//  JHAnalyseControlAnalyseNode.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/4.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHAnalyseControlAnalyseNode.h"

@implementation JHAnalyseControlAnalyseNode
+(void)load{
    Method JH_sendAction = class_getInstanceMethod([UIControl class], @selector(sendAction:to:forEvent:));
    class_addMethod([UIControl class], @selector(JHhook_sendAction:to:forEvent:), method_getImplementation(JH_sendAction), method_getTypeEncoding(JH_sendAction));
    method_setImplementation(JH_sendAction, class_getMethodImplementation([self class], @selector(JHhook_sendAction:to:forEvent:)));
    
    
}
/**
 替换的方法
 */
-(void)JHhook_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event{
    
    NSString *methodName = NSStringFromSelector(action);
    NSString *className = [NSString stringWithUTF8String: object_getClassName(target)];
    UIControl *sender = (UIControl *)self;
    //第一层，视图ClassName
    NSDictionary *data = [[JHAnalyseControlAnalyseNode class]getJsonData];
    if ([[data allKeys]containsObject:className]) {
        //第二层，Action
        NSDictionary *class = data[className];
        if([[class allKeys]containsObject:methodName]){
            NSDictionary *action = class[methodName];
            
            NSString *tag = [NSString stringWithFormat:@"%ld",sender.tag];
            if([[action allKeys]containsObject:tag]){
                NSDictionary *oneAction = action[tag];
                NSLog(@"mtthodName=%@,className=%@,classRealName=%@tag=%@",methodName,className,oneAction[@"name"],tag);
                //组合数据并存入数据库
                NSDictionary *eventDic = @{@"eventClass":oneAction[@"name"],
                                           @"eventCodeName":className,
                                           @"eventCount":@"1",
                                           @"eventDate":@"时间暂时不需要",
                                           @"eventName":methodName,
                                           @"eventTag":tag,
                                           @"eventUser":@"jianghong",
                                           };
                [JH_AnalyseDataHelper _AnalyseWithData:eventDic withType:AnalyseTypeEvent];
            }
        }
    }
    
    [self JHhook_sendAction:action to:target forEvent:event];
    
}
+(NSDictionary *)getJsonData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"analyse" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic[@"event"];
}
@end

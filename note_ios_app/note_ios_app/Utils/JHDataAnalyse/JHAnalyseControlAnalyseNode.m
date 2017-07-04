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
    NSDictionary *data = [[JHAnalyseControlAnalyseNode class]getJsonData];
    if ([[data allKeys]containsObject:className]) {
        NSString *tag = [NSString stringWithFormat:@"%ld",sender.tag];
        NSDictionary *class = data[className];
        if([[class allKeys]containsObject:tag]){
            NSDictionary *oneAction = class[tag];
            NSLog(@"mtthodName=%@,className=%@,tag=%@",methodName,oneAction[@"name"],tag);
        }
        
    };
    
    
    [self JHhook_sendAction:action to:target forEvent:event];
    
}
+(NSDictionary *)getJsonData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"analyse" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic[@"event"];
}
@end

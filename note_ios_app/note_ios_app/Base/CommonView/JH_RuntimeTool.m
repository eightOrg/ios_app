//
//  JH_RuntimeTool.m
//  haoqibaoyewu
//
//  Created by hyjt on 2016/11/28.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "JH_RuntimeTool.h"
#import <objc/message.h>
@implementation JH_RuntimeTool
//创建一个对象
+(id)creatClass:(NSString *)vcName{
    //类名(对象名)
    
    NSString *class = vcName;
    
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    return [[newClass alloc] init];
}
// push控制器
+ (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav {
    //类名(对象名)
    
    NSString *class = vcName;
    
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    
    //下面是传值－－－－－－－－－－－－－－
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            //kvc给属性赋值
            NSLog(@"%@,%@",obj,key);
            [instance setValue:obj forKey:key];
        }else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];

    UIViewController *vc = instance;
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
    
}
/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    // 再遍历父类中的属性
    Class superClass = class_getSuperclass([instance class]);
    
    //通过下面的方法获取属性列表
    unsigned int outCount2;
    objc_property_t *properties2 = class_copyPropertyList(superClass, &outCount2);
    
    for (int i = 0 ; i < outCount2; i++) {
        objc_property_t property2 = properties2[i];
        //  属性名转成字符串
        NSString *propertyName2 = [[NSString alloc] initWithCString:property_getName(property2) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName2 isEqualToString:verifyPropertyName]) {
            free(properties2);
            return YES;
        }
    }
    free(properties2); //释放数组
    
    return NO;
}

/**
 获取协议列表
 
 @param class 一个类
 @return 协议名字数组
 */
+ (NSArray *)fetchProtocolList:(Class)class {
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String: protocolName]];
    }
    
    free(protocolList);
    return [NSArray arrayWithArray:mutableList];
    
}

/**
 为一个类添加来自别的类的协议

 @param class 目标类
 @param fromClass 来源类
 */
+(void)addProtocolForClass:(Class )class fromClass:(Class)fromClass{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(fromClass, &count);
    
    for (unsigned int i = 0; i < count; i++ ) {
        Protocol *protocol = protocolList[i];
        class_addProtocol(class, protocol);
    }
    free(protocolList);
}
/**
 获取类名
 
 @param class 相应类
 @return NSString：类名
 */
+ (NSString *)fetchClassName:(Class)class {
    const char *className = class_getName(class);
    return [NSString stringWithUTF8String:className];
}

/**
 获取成员变量
 
 @param class Class
 @return NSArray
 */
+ (NSArray *)fetchIvarList:(Class)class {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dic[@"type"] = [NSString stringWithUTF8String: ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String: ivarName];
        
        [mutableList addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

/**
 获取类的属性列表, 包括私有和公有属性，以及定义在延展中的属性
 
 @param class Class
 @return 属性列表数组
 */
+ (NSArray *)fetchPropertyList:(Class)class {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        const char *propertyName = property_getName(propertyList[i]);
        [mutableList addObject:[NSString stringWithUTF8String: propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:mutableList];
}


/**
 获取类的实例方法列表：getter, setter, 对象方法等。但不能获取类方法
 
 @param class <#class description#>
 @return <#return value description#>
 */
+ (NSArray *)fetchMethodList:(Class)class {
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];
}


/**
 往类上添加新的方法与其实现
 
 @param class 相应的类
 @param methodSel 方法的名
 @param methodSelImpl 对应方法实现的方法名
 */
+ (void)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImpl {
    Method method = class_getInstanceMethod(class, methodSelImpl);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(class, methodSel, methodIMP, types);
}

/**
 方法交换
 
 @param class 交换方法所在的类
 @param method1 方法1
 @param method2 方法2
 */
+ (void)methodSwap:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2 {
    Method firstMethod = class_getInstanceMethod(class, method1);
    Method secondMethod = class_getInstanceMethod(class, method2);
    method_exchangeImplementations(firstMethod, secondMethod);
}
@end

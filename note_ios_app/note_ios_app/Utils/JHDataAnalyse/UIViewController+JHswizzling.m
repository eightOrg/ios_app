//
//  UIViewController+JHswizzling.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/4.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "UIViewController+JHswizzling.h"
static NSDate *startDate;
@implementation UIViewController (JHswizzling)
+ (void)load{
    
    
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
    Method toMethod = class_getInstanceMethod([self class], @selector(JH_swizzlingViewDidAppear));
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(JH_swizzlingViewDidAppear), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
    
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method fromMethodDis = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method toMethodDis = class_getInstanceMethod([self class], @selector(JH_swizzlingViewDidDisAppear));
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(JH_swizzlingViewDidDisAppear), method_getImplementation(toMethodDis), method_getTypeEncoding(toMethodDis))) {
        method_exchangeImplementations(fromMethodDis, toMethodDis);
    }
}

// 我们自己实现的方法，也就是和self的viewDidAppear方法进行交换的方法。
- (void)JH_swizzlingViewDidAppear{
    
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if(![str containsString:@"UI"]){
    
        NSDictionary *data = [self getJsonData];
        if ([[data allKeys]containsObject:str]) {
#warning 存在present视图的时候先走appear再disappear，考虑到时间较短这里可以加个简单的延迟,否则startDate被篡改
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    startDate = [NSDate  date];
                });
                //            NSLog(@"统计打点出现 : %@ time : %@", [self getJsonData][str] ,startDate);
        }
        
    }
    [self JH_swizzlingViewDidAppear];
}

// 我们自己实现的方法，也就是和self的viewDidDisAppear方法进行交换的方法。
- (void)JH_swizzlingViewDidDisAppear{
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"]){
        // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
        NSDictionary *data = [self getJsonData];
        if ([[data allKeys]containsObject:str]) {
            //计算时间差
            NSDate *endDate = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            
            NSInteger interval = [zone secondsFromGMTForDate: endDate];
            
            NSDate *localeDate = [endDate  dateByAddingTimeInterval: interval];
            
            NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
            NSLog(@"视图消失 : %@ time : %f 时长", data[str] ,duration);
            //组合数据并存入数据库
            NSDictionary *vcDic = @{@"viewControllerCodeName":str,
                                    @"viewControllerName":data[str],
                                    @"viewControllerTime":[NSString stringWithFormat:@"%f",duration],
                                    @"viewControllerDate":[NSString stringWithFormat:@"%@",localeDate]
                                    };
            [JH_AnalyseDataHelper _AnalyseWithData:vcDic withType:AnalyseTypeViewController];
            
        }
    }
    
    
    [self JH_swizzlingViewDidDisAppear];
}

-(NSDictionary *)getJsonData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"analyse" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic[@"viewController"];
}

@end

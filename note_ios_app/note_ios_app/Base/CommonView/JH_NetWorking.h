//
//  JH_NetWorking.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/22.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef NS_ENUM(NSInteger ,HttpMethod) {
    HttpMethodGet,
    HttpMethodPost,
    HttpMethodDelete
};
@interface JH_NetWorking : NSObject
@property(nonatomic,strong)AFHTTPSessionManager *sessionManager;
+(JH_NetWorking *)shareNetWorking;

//使用普通keyvalue的网络请求
+ (void)requestData:(NSString *)urlString HTTPMethod:(HttpMethod )method showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
//利用json方式的网络请求
+ (void)requestDataByJson:(NSString *)urlString HTTPMethod:(HttpMethod )method showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
//上传附件的网络请求
+ (void)requestDataAndFormData:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;
/**
 专为宇为系统增加的请求
 
 @param dic 原始数据
 @return 增加了身份验证的请求
 */
+(NSDictionary *)addKeyAndUIdForRequest:(NSDictionary *)dic;
//自定义安全策略
+ (AFSecurityPolicy*)customSecurityPolicy;

/**
 同步请求
 */
+(id)sendSynchronousRequest:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params;

@end

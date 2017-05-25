//
//  JH_NetWorking.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/22.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "JH_NetWorking.h"
//#import "CarFinanceAppDelegate+StartAPP.h"
static JH_NetWorking *afsingleton = nil;
static NSInteger timeout = 15;
@implementation JH_NetWorking
/**
 将AFNetWoeking网络请求，分装在一个单例的方法中，重用AFHTTPSessionManager
 */
+(JH_NetWorking *)shareNetWorking{
    @synchronized (self) {
        if (afsingleton==nil) {
            afsingleton = [[super allocWithZone:nil]init];
            afsingleton.sessionManager = [AFHTTPSessionManager manager];
            afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
            //afsingleton.sessionManager.securityPolicy = [[self class] customSecurityPolicy];
        }
    }
    return afsingleton;
}

+ (void)requestData:(NSString *)urlString HTTPMethod:(HttpMethod )method showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock{
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    //URL编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MBProgressHUD *hud;
    if (showHud) {
        
        //hub
        hud = [MBProgressHUD MBProgressShowProgressWithTitle:@"正在加载..." view:[UIApplication sharedApplication].keyWindow];
        
    }
    //发送异步网络请求
    afsingleton.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
    
    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
    
    //GET和POSTDelete分别处理
    if (method == HttpMethodGet) {
        [afsingleton.sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"code"]isEqualToString:@"10005"]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        
        [afsingleton.sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"code"]isEqualToString:@"10005"]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
             [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
            
        }];

    }else if (method == HttpMethodDelete){
        [afsingleton.sessionManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"code"]isEqualToString:@"10005"]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
        }];
        
    }
    
}

//利用json方式的网络请求
+ (void)requestDataByJson:(NSString *)urlString HTTPMethod:(HttpMethod )method showHud:(BOOL)showHud params:(NSDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock{
    
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MBProgressHUD *hud;
    if (showHud) {
        
        //hub
        hud = [MBProgressHUD MBProgressShowProgressWithTitle:@"正在加载..." view:[UIApplication sharedApplication].keyWindow];
        
    }
    //发送异步网络请求
    
    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
    afsingleton.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;
    
    //GET和POST分别处理
    if (method == HttpMethodGet) {
        [afsingleton.sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //hideMB
            [hud hideAnimated:YES];
            
            //判断是否登录过期
            if ([responseObject[@"error"]isEqual:@0]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        
        [afsingleton.sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"error"]isEqual:@0]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
            
        }];
        
        
    }else if (method == HttpMethodDelete){
        [afsingleton.sessionManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //hideMB
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"error"]isEqual:@0]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //hideMB
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
        }];
        
    }
}
//上传附件的网络请求
+ (void)requestDataAndFormData:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock{
    if (afsingleton==nil) {
        [[self class ] shareNetWorking];
    }
    //编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD MBProgressShowProgressViewWithTitle:@"正在上传..." view:[UIApplication sharedApplication].keyWindow];
    //发送异步网络请求
    
    [afsingleton.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    //    [manager.requestSerializer setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type" ];
    afsingleton.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    afsingleton.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    afsingleton.sessionManager.requestSerializer.timeoutInterval = timeout;

    //GET和POST分别处理
    if (method == HttpMethodGet) {
        
        [afsingleton.sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //判断是否登录过期
            if ([responseObject[@"code"]isEqualToString:@"10005"]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            errorblock(error);
            
        }];
        
    }
    else if(method == HttpMethodPost) {
        [afsingleton.sessionManager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //处理formData
            for (NSDictionary *data in formDataArray) {
                
                [formData appendPartWithFileData:data[@"fileData"] name:data[@"name"] fileName:data[@"fileName"] mimeType:data[@"mimeType"]];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //必须在主线程中更新progress！！！！
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hud.progress = uploadProgress.fractionCompleted;
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hideAnimated:YES];
            //判断是否登录过期
            if ([responseObject[@"code"]isEqualToString:@"10005"]) {
                [[self class]goToLogin];
            } else {
                
                //block回调
                completionblock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"请检查您的网络状态，或与管理员联系！" view:[UIApplication sharedApplication].keyWindow];
            errorblock(error);
        }];
    }
    
}

/**
 专为宇为系统增加的请求

 @param dic 原始数据
 @return 增加了身份验证的请求
 */
+(NSDictionary *)addKeyAndUIdForRequest:(NSDictionary *)dic{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:dic];

    
    return data;
}
/**
 由于token过期造成的登录过期，强制退出
 */
+(void)goToLogin{
    //删除保存的登录信息

    
    [MBProgressHUD MBProgressShowSuccess:NO WithTitle:@"登陆过期，请重新登录" view:[UIApplication sharedApplication].keyWindow];

        //发送通知使登录

    
}

//自定义安全策略
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xiaoxin" ofType:@"cer"];//证书的路径
    //    NSString * cerPath = [[NSBundle mainBundle]pathForResource:@"https" ofType:@"cer"];
    
    //    NSLog(@"%@",cerPath);
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    NSLog(@"%@",certData);
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}
+(id)sendSynchronousRequest:(NSString *)urlString HTTPMethod:(HttpMethod )method  params:(NSDictionary *)params{
    
    
    //3.处理请求参数
    //key1=value1&key2=value2
    NSMutableString *paramString = [NSMutableString string];
    
    NSArray *allKeys = params.allKeys;
    
    for (NSInteger i = 0; i < params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count - 1) {
            [paramString appendString:@"&"];
        }
        
    }
    //编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    //2.创建网络请求
    NSMutableURLRequest *request;
    //4.GET和POST分别处理
    if (method ==HttpMethodGet) {
        
        //http://www.baidu.com?key1=value1&key2=value2
        //http://www.baidu.com?key0=value0&key1=value1&key2=value2
        
        NSString *seperate = url.query ? @"&" : @"?";
        urlString = [NSString stringWithFormat:@"%@%@%@",urlString,seperate,paramString];
        //编码
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //根据拼接好的URL进行修改
        NSURL *finalUrl = [NSURL URLWithString:urlString];
        request = [[NSMutableURLRequest alloc]initWithURL:finalUrl cachePolicy:0 timeoutInterval:15];
        request.HTTPMethod = @"GET";
    }
    else if(method ==HttpMethodPost) {
        //POST请求则把参数放在请求体里
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:15];
        NSData *bodyData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
        request.HTTPBody = bodyData;
    }
    
    // 发送一个同步请求(在主线程发送请求)
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //解析JSON
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDic;
}

@end

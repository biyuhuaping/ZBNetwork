//
//  ZBNetwork.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBNetwork.h"

@interface ZBNetwork ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ZBNetwork

+ (instancetype)defaultManager {
    static ZBNetwork *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.requestSerializer.timeoutInterval = 20.0;// 设置超时时间
        manager.sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    });
    return manager;
}

#pragma mark - GET, POST 网络请求
/**
 get请求
 */
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure{
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//        ShowMessage(dataInfoMessage);
        return;
    }
    [self sendRequestMethod:HTTPMethodGET requestPath:URLString parameters:parameters progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        BOOL isValid = [[self defaultManager] networkResponseData:responseObject];
//            BOOL result = [responseObject[@"result"] boolValue];
        BOOL status = [responseObject[@"status"] intValue];
        if (success && isValid && !status) {
            success(responseObject);
        }else{
            NSString *message = responseObject[@"message"];
            //                ShowMessage(message);
            failure([message copy]);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure([errorMessage copy]);
    }];
}

/**
 post请求
 */
+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure{
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//        ShowMessage(dataInfoMessage);
        return;
    }
    [self sendRequestMethod:HTTPMethodPOST requestPath:URLString parameters:parameters progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        BOOL isValid = [[self defaultManager] networkResponseData:responseObject];
        if (success && isValid) {
            success(responseObject);
        }else{
            NSString *message = responseObject[@"msg"];
//                ShowMessage(responseObject[@"msg"]);
            failure([message copy]);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure([errorMessage copy]);
    }];
}

#pragma mark - 
#pragma mark - 常用网络请求(GET, POST, PUT, PATCH, DELETE)
/**
 常用网络请求方式
 
 @param requestMethod 请求方试
 @param requestPath 请求地址
 @param parameters 参数
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
+ (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod requestPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString * _Nullable errorMessage))failure {
    NSLog(@"\n==============================请求的地址:==============================\n%@\n=====================================================================\n",requestPath);
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET: {
            task = [[[self defaultManager] sessionManager] GET:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPOST: {
            task = [[[self defaultManager] sessionManager] POST:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPUT: {
            task = [[[self defaultManager] sessionManager] PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPATCH: {
            task = [[[self defaultManager] sessionManager] PATCH:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodDELETE: {
            task = [[[self defaultManager] sessionManager] DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
    }
    return task;
}

/**
 上传图片
 
 @param requestPath 服务器地址
 @param parameters 参数
 @param imageArray 图片
 @param width 图片宽度
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
+ (nullable NSURLSessionDataTask *)sendPOSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters imageArray:(NSArray *_Nullable)imageArray targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure {
    NSURLSessionDataTask * task = nil;
    task = [[[self defaultManager] sessionManager] POST:requestPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i = 0 ;
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            // 压缩图片，指定宽度（注释：imageCompressed：withdefineWidth：图片压缩的category）
//            UIImage *  resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
            NSData * imgData = UIImageJPEGRepresentation(image, 0.5);
            // 拼接Data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            i++;
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
    }];
    return task;
}


/**
 上传文件

 @param url 服务器地址
 @param data data类型的文件
 @param name 名称
 @param fileName 文件名
 @param mimeType 文件类型
 @param progress 上传进度
 @param success 成功
 @param failure 失败
 @return 返回
 */
+ (nullable NSURLSessionDataTask *)POSTFileWithUrl:(NSString *_Nullable)url fileData:(NSData *_Nullable)data name:(NSString *_Nonnull)name fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nonnull)mimeType progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure{
    NSURLSessionDataTask * session = nil;
    session = [[[self defaultManager] sessionManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure([[self defaultManager] failHandleWithErrorResponse:error task:task]);
    }];
    return session;
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
- (BOOL)networkResponseData:(id)responseObject{
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
//    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"%@",json);
    
    //统一判断所有请求返回状态，例如：强制更新为6，若为6就返回YES，
    int stat = 0;
    switch (stat) {
        case -1:{//强制退出
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消");
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"点击了确定");
            }]];
            
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
            return NO;
        }
            break;
        case -2:{//强制更新
            return NO;
        }
            break;
        case -3:{//弹出对话框
            return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSLog(@"afNetworking_errorMsg == %@",[[NSString alloc]initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding]);
    __block NSString *message = nil;
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        message = responseObject[@"error"];
    }
    NSLog(@"error == %@",error);
    return message;
}

@end

//
//  ZBNetwork.h
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};

@interface ZBNetwork : NSObject

#pragma mark - 常用网络请求
/**
 get请求
  */
+ (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure;

/**
 post请求
  */
+ (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure;


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
+ (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod requestPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString * _Nullable errorMessage))failure;

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
+ (nullable NSURLSessionDataTask *)sendPOSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters imageArray:(NSArray *_Nullable)imageArray targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure;

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
+ (nullable NSURLSessionDataTask *)POSTFileWithUrl:(NSString *_Nullable)url fileData:(NSData *_Nullable)data name:(NSString *_Nonnull)name fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nonnull)mimeType progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure;

@end

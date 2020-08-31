//
//  WBHTTPService.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC.h>
#import "WBHTTPRequest.h"
#import "WBHTTPServiceConstant.h"

#import "WBUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBHTTPService : AFHTTPSessionManager

+ (instancetype)shareHttpService;

// MARK: - 用户信息存储
@property (nonatomic, strong, nullable) WBUser *currentUser;

- (void)saveUser:(WBUser *)user;
- (void)deleteUser:(WBUser *)user;
- (void)loginUser:(WBUser *)user;
- (void)logoutUser;

@end

@interface WBHTTPService (Request)

/// 1. 使用须知：后台返回数据的保证为👇固定格式 且`data:{}`必须为`字典`或者`NSNull`;
/// {
///    code：0,
///    msg: "",
///    data:{
///    }
/// }
/// 这个方法返回的 signal 将会 send `MHHTTPResponse`这个实例，`parsedResult`就是对应键data对应的值， 如果你想获得里面的parsedResult实例，请使用以下方法
/// [[self enqueueRequest:request resultClass:SBUser.class] sb_parsedResults];
/// 这样取出来的就是 SBUser对象

/// 2.使用方法如下
/*
 /// 1. 配置参数
 SBKeyedSubscript *subscript = [SBKeyedSubscript subscript];
 subscript[@"page"] = @1;
 
 /// 2. 配置参数模型
 SBURLParameters *paramters = [SBURLParameters urlParametersWithMethod:@"GET" path:SUProduct parameters:subscript.dictionary];
 
 /// 3. 创建请求
 /// 3.1 resultClass 传入对象必须得是 MHObject的子类
 /// 3.2 resultClass 传入nil ，那么回调回来的值就是，服务器返回来的数据
 [[[[MHHTTPRequest requestWithParameters:paramters]
 enqueueResultClass:[SBGoodsData class]]
 sb_parsedResults]
 subscribeNext:^(SBGoodsData * goodsData) {
 /// 成功回调
 
 } error:^(NSError *error) {
 /// 失败回调
 
 } completed:^{
 /// 完成
 
 }];
 
 */

/**
 Enqueues a request to be sent to the server.
 This will automatically fetch a of the given endpoint. Each object
 from each page will be sent independently on the returned signal, so
 subscribers don't have to know or care about this pagination behavior.
 
 @param request config the request
 @param resultClass A subclass of `MHObject` that the response data should be returned as,
 and will be accessible from the `parsedResult`
 @return Returns a signal which will send an instance of `MHHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
- (RACSignal *)enqueueRequest:(WBHTTPRequest *) request
                  resultClass:(Class /*subclass of MHObject*/)resultClass;

/**
 用来上传多个文件流，也可以上传单个文件
 
 @param request MHHTTPRequest
 @param resultClass 要转化出来的请求结果且必须是 `MHObject`的子类，否则Crash
 @param fileDatas 要上传的 文件数据，数组里面必须是装着` NSData ` 否则Crash
 @param name  这个是服务器的`资源文件名`，这个服务器会给出具体的数值，不能传nil 否则 Crach
 @param mimeType http://www.jianshu.com/p/a3e77751d37c 如果传nil ，则会传递 application/octet-stream
 @return Returns a signal which will send an instance of `MHHTTPResponse` for each parsed
 JSON object, then complete. If an error occurs at any point,
 the returned signal will send it immediately, then terminate.
 */
- (RACSignal *)enqueueUploadRequest:(WBHTTPRequest *) request
                        resultClass:(Class /*subclass of MHObject*/)resultClass
                          fileDatas:(NSArray <NSData *> *)fileDatas
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END

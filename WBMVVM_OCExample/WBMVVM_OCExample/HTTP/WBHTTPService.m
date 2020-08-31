//
//  WBHTTPService.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBHTTPService.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "WBModel.h"
#import "WBHTTPResponse.h"
#import "WBConstInline.h"
#import "NSKeyedUnarchiver+WBAdd.h"
#import "NSString+WBAdd.h"

static NSString *const kWBUserDataFileName = @"senba_empty_user.data";
static id instance = nil;

@implementation WBHTTPService

+ (instancetype)shareHttpService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://live.9158.com/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

// MARK: - 初始化配置
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        [self _configHTTPService];
    }
    return self;
}

- (void)_configHTTPService {
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if DEBUG
        responseSerializer.removesKeysWithNullValues = NO;
#else
        responseSerializer.removesKeysWithNullValues = YES;
#endif
        responseSerializer.readingOptions = NSJSONReadingAllowFragments;
        /// config
        self.responseSerializer = responseSerializer;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        /// 安全策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO
        //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        securityPolicy.validatesDomainName = NO;
        
        self.securityPolicy = securityPolicy;
        /// 支持解析
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                          @"text/json",
                                                          @"text/javascript",
                                                          @"text/html",
                                                          @"text/plain",
                                                          @"text/html; charset=UTF-8",
                                                          nil];
        
        /// 开启网络监测
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if (status == AFNetworkReachabilityStatusUnknown) {
                //            [JDStatusBarNotification showWithStatus:@"网络状态未知" styleName:JDStatusBarStyleWarning];
                //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
                NSLog(@"--- 未知网络 ---");
            }else if (status == AFNetworkReachabilityStatusNotReachable) {
                //            [JDStatusBarNotification showWithStatus:@"网络不给力，请检查网络" styleName:JDStatusBarStyleWarning];
                //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
                NSLog(@"--- 无网络 ---");
            }else{
                NSLog(@"--- 有网络 ---");
                //            [JDStatusBarNotification dismiss];
            }
        }];
        [self.reachabilityManager startMonitoring];
}


// MARK: - Request
- (RACSignal *)enqueueRequest:(WBHTTPRequest *)request
                  resultClass:(Class)resultClass {
    /// request 必须的有值
    if (request == nil) return [RACSignal error:[NSError errorWithDomain:WBHTTPServiceErrorDomain code:-1 userInfo:nil]];
    
    @weakify(self);
    return [[[self enqueueRequestWithPath:request.urlParameters.path
                               parameters:request.urlParameters.parameters
                                   method:request.urlParameters.method] reduceEach:^RACStream *_Nonnull(NSURLResponse *response, NSDictionary * responseObject) {
        @strongify(self);
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^id _Nullable(id  _Nullable parsedResult) {
            WBHTTPResponse *parsedResponse = [[WBHTTPResponse alloc] initWithResponseObject:responseObject
                                                                               parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }] concat];
}

/// 解析数据
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(NSDictionary *)responseObject {
    NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:WBModel.class]));
    
    /// 这里主要解析的是 data:对应的数据
    responseObject = responseObject[WBHTTPServiceResponseDataKey];
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        
        /// 解析字典
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (resultClass == nil) {
                [subscriber sendNext:JSONDictionary];
                return;
            }
            
            /// 这里继续取出数据 data{"list":[]}
            NSArray *JSONArray = JSONDictionary[WBHTTPServiceResponseListKey];
            if ([JSONArray isKindOfClass:NSArray.class]) {
                /// 字典数组 转对应的模型
                NSArray *parsedArray = [NSArray yy_modelArrayWithClass:resultClass json:JSONArray];
                for (id parsedObject in parsedArray) {
                    /// 确保解析出来的类 也是 WBModel
                    NSAssert([parsedObject isKindOfClass:WBModel.class], @"Parsed model object is not an MHObject: %@", parsedObject);
                }
                
                [subscriber sendNext:parsedArray];
            } else {
                WBModel *parsedObject = [WBModel modelWithJSON:JSONDictionary];
                if (parsedObject == nil) {
                    // Don't treat "no class found" errors as real parsing failures.
                    // In theory, this makes parsing code forward-compatible with
                    // API additions.
                    // 模型解析失败
                    NSError *error = [NSError errorWithDomain:@"" code:2222 userInfo:@{}];
                    [subscriber sendError:error];
                    return;
                }
                
                /// 确保解析出来的类 也是 WBModel
                NSAssert([parsedObject isKindOfClass:WBModel.class], @"Parsed model object is not an MHObject: %@", parsedObject);
                /// 发送数据
                [subscriber sendNext:parsedObject];
            }
        };
        
        if ([responseObject isKindOfClass:NSArray.class]) {
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            } else {
                /// 数组 保证数组里面装的是同一种 NSDcitionary
                for (NSDictionary *JSONDictionary in responseObject) {
                    if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                        [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                        return nil;
                    }
                }
                
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:responseObject];
                
                /// 这里还需要解析是否是MHObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 BaseModel
                    NSAssert([parsedObject isKindOfClass:WBModel.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            parseJSONDictionary(responseObject);
            [subscriber sendCompleted];
        } else if (responseObject == nil || [responseObject isKindOfClass:NSNull.class]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        
        return nil;
    }];
}

- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    return [NSError errorWithDomain:WBHTTPServiceErrorDomain code:WBHTTPServiceErrorJSONParsingFailed userInfo:userInfo];
}

/// 请求数据
- (RACSignal *)enqueueRequestWithPath:(NSString *)path
                           parameters:(id)parameters
                               method:(NSString *)method {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                       URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                                      parameters:parameters
                                                                           error:&serializationError];
        
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        
        /// 获取请求任务
        __block NSURLSessionTask *task = nil;
        task = [self dataTaskWithRequest:request
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSError *parseError = [self _errorFromRequestWithTask:task
                                                         httpResponse:(NSHTTPURLResponse *)response
                                                       responseObject:responseObject
                                                                error:error];
                [self HTTPRequestLog:task
                                body:parameters
                               error:parseError];
                [subscriber sendError:parseError];
            } else {
                
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                /// 在这里判断数据是否正确
                /// 判断
                NSInteger statusCode = [responseObject[WBHTTPServiceResponseCodeKey] integerValue];
                /// 请求成功状态
                if (statusCode == WBHTTPResponseCodeSuccess) {
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response, responseObject)];
                    [subscriber sendCompleted];
                } else {
                    if (statusCode == WBHTTPResponseCodeNotLogin) {
                        /// 重新登录
                    } else {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        userInfo[WBHTTPServiceErrorResponseCodeKey] = @(statusCode);
                        NSString *msgTips = responseObject[WBHTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                        msgTips = ![NSString wb_isEmpty:msgTips] ? [NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
#else
                        msgTips = MHStringIsNotEmpty(msgTips) ? msgTips : @"服务器出错了，请稍后重试~";  /// 发布模式
#endif
                        userInfo[WBHTTPServiceErrorMessagesKey] = msgTips;
                        if (task.currentRequest.URL != nil) userInfo[WBHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                        if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                        [subscriber sendError:[NSError errorWithDomain:WBHTTPServiceErrorDomain code:statusCode userInfo:userInfo]];
                    }
                }
            }
        }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal replayLazily] setNameWithFormat:@"-enqueueRequestWithPath: %@ parameters: %@ method: %@", path, parameters, method];
}

// MARK: - Upload
- (RACSignal *)enqueueUploadRequest:(WBHTTPRequest *)request
                        resultClass:(Class)resultClass
                          fileDatas:(NSArray<NSData *> *)fileDatas
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType {
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:WBHTTPServiceErrorDomain code:-1 userInfo:nil]];
    /// 断言
    NSAssert(![NSString wb_isEmpty:name], @"name is empty: %@", name);
    
    @weakify(self);
    /// 覆盖manager 请求序列化
    return [[[self enqueueUploadRequestWithPath:request.urlParameters.path
                                     parameters:request.urlParameters.parameters
                      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        @strongify(self);
        
        NSInteger count = fileDatas.count;
        for (int i = 0; i < count; i ++) {
            NSData *fileData = fileDatas[i];
            
            /// 断言
            NSAssert([fileData isKindOfClass:NSData.class], @"fileData is not an NSData class: %@", fileData);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            static NSDateFormatter *formatter = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                formatter = [[NSDateFormatter alloc] init];
            });
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"senba_empty_%@_%d.jpg", dateString, i];
            
            [formData appendPartWithFileData:fileData
                                        name:name
                                    fileName:fileName
                                    mimeType:![NSString wb_isEmpty:mimeType] ? mimeType : @"application/octet-stream"];
        }
    }] reduceEach:^RACStream *(NSURLResponse *response, NSDictionary *responseObject) {
        @strongify(self);
        /// 请求成功 这里解析数据
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^id _Nullable(id parsedResult) {
            WBHTTPResponse *parsedResponse = [[WBHTTPResponse alloc] initWithResponseObject:responseObject
                                                                               parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }] concat];
}

- (RACSignal *)enqueueUploadRequestWithPath:(NSString *)path
                                 parameters:(id)parameters
                  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    @weakify(self);
     /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        
        NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                    URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                                                   parameters:parameters
                                                                    constructingBodyWithBlock:block
                                                                                        error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        
        __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request
                                                                        progress:nil
                                                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
                [self HTTPRequestLog:task body:parameters error:parseError];
                [subscriber sendError:parseError];
            } else {
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                /// 在这里判断数据是否正确
                /// 判断
                NSInteger statusCode = [responseObject[WBHTTPServiceResponseCodeKey] integerValue];
                /// 请求成功状态
                if (statusCode == WBHTTPResponseCodeSuccess) {
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response, responseObject)];
                    [subscriber sendCompleted];
                } else {
                    if (statusCode == WBHTTPResponseCodeNotLogin) {
                        /// 重新登录
                    } else {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        userInfo[WBHTTPServiceErrorResponseCodeKey] = @(statusCode);
                        NSString *msgTips = responseObject[WBHTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                        msgTips = ![NSString wb_isEmpty:msgTips] ? [NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~", statusCode];                 /// 调试模式
#else
                        msgTips = MHStringIsNotEmpty(msgTips) ? msgTips : @"服务器出错了，请稍后重试~";  /// 发布模式
#endif
                        userInfo[WBHTTPServiceErrorMessagesKey] = msgTips;
                        if (task.currentRequest.URL != nil) userInfo[WBHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                        if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                        [subscriber sendError:[NSError errorWithDomain:WBHTTPServiceErrorDomain code:statusCode userInfo:userInfo]];
                    }
                }
            }
        }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal
             replayLazily]
            setNameWithFormat:@"-enqueueUploadRequestWithPath: %@ parameters: %@", path, parameters];
}

// MARK: - Error handing
/// 请求错误解析
- (NSError *)_errorFromRequestWithTask:(NSURLSessionTask *)task
                          httpResponse:(NSHTTPURLResponse *)httpResponse
                        responseObject:(NSDictionary *)responseObject
                                 error:(NSError *)error {
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is WBHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = WBHTTPServiceErrorConnectionFailed;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode / 100;
    if (httpFirstCode > 0) {
        if (httpFirstCode == 4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(408)~"; /// 调试模式
#else
                errorDesc = @"请求超时，请稍后再试~";      /// 发布模式
#endif
            }else{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",HTTPCode];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";      /// 发布模式
#endif
            }
        }else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
#if defined(DEBUG)||defined(_DEBUG)
            errorDesc = [NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",HTTPCode];                      /// 调试模式
#else
            errorDesc = @"服务器出错了，请稍后重试~";       /// 发布模式
#endif
            
        }else if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }else{
        if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    switch (HTTPCode) {
        case 400:{
            errorCode = WBHTTPServiceErrorBadRequest;           /// 请求失败
            break;
        }
        case 403:{
            errorCode = WBHTTPServiceErrorRequestForbidden;     /// 服务器拒绝请求
            break;
        }
        case 422:{
            errorCode = WBHTTPServiceErrorServiceRequestFailed; /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",error.code];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";        /// 发布模式
#endif
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:
                        errorCode = WBHTTPServiceErrorSecureConnectionFailed; /// 建立安全连接出错了
                        break;
                    case NSURLErrorTimedOut:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
#else
                        errorDesc = @"请求超时，请稍后再试~";        /// 发布模式
#endif
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"网络开小差了，请稍后重试(-1009)~"; /// 调试模式
#else
                        errorDesc = @"网络开小差了，请稍后重试~";        /// 发布模式
#endif
                        break;
                    }
                }
            }
    }
    userInfo[WBHTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[WBHTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[WBHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    return [NSError errorWithDomain:WBHTTPServiceErrorDomain code:errorCode userInfo:userInfo];
}

// MARK: - LOG
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:params error:(NSError *)error {
    NSLog(@">>>>>>>>>>>>>>>>>>>>>👇 REQUEST FINISH 👇>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"Request%@=======>:%@", error ? @"失败" : @"成功", task.currentRequest.URL.absoluteString);
    NSLog(@"requestBody======>:%@", params);
    NSLog(@"requstHeader=====>:%@", task.currentRequest.allHTTPHeaderFields);
    NSLog(@"response=========>:%@", task.response);
    NSLog(@"error============>:%@", error);
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<");
}

// MARK: - 用户信息存储
- (WBUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [NSKeyedUnarchiver wb_unarchiveObjectWithFile:WBFilePathFromAPPDoc(kWBUserDataFileName) cls:WBUser.class exception:nil];
    }
    return _currentUser;
}

- (void)saveUser:(WBUser *)user {
    self.currentUser = user;
    
    /// 保存
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:WBFilePathFromAPPDoc(kWBUserDataFileName)];
    NSLog(@"Save login user data， the status is %@",status ? @"Success...":@"Failure...");
}

- (void)deleteUser:(WBUser *)user {
    self.currentUser = nil;
    
    [self saveUser:self.currentUser];
}

- (void)loginUser:(WBUser *)user {
    [self saveUser:user];
}

- (void)logoutUser {
    [self deleteUser:self.currentUser];
}

@end

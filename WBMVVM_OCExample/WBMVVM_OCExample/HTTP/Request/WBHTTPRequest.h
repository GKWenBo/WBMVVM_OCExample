//
//  WBHTTPRequest.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "WBURLParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBHTTPRequest : NSObject

/// 请求参数
@property (nonatomic, readonly, strong) WBURLParameters *urlParameters;
/**
 获取请求类
 @param parameters  参数模型
 @return 请求类
 */
+ (instancetype)requestWithParameters:(WBURLParameters *)parameters;

@end

@interface WBHTTPRequest (WBHTTPService)

/// 入队
- (RACSignal *)enqueueResultClass:(Class /*subclass of MHObject*/)resultClass;

@end

NS_ASSUME_NONNULL_END

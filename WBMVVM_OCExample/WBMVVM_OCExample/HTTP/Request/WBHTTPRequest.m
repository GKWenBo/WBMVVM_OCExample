//
//  WBHTTPRequest.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBHTTPRequest.h"
#import "WBHTTPService.h"

@interface WBHTTPRequest ()

/// 请求参数
@property (nonatomic, readwrite, strong) WBURLParameters *urlParameters;

@end

@implementation WBHTTPRequest

+ (instancetype)requestWithParameters:(WBURLParameters *)parameters {
    return [[self alloc] initRequestWithParameters:parameters];
}

- (instancetype)initRequestWithParameters:(WBURLParameters *)parameters{
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}

@end


@implementation WBHTTPRequest (WBHTTPService)

/// 入队
- (RACSignal *)enqueueResultClass:(Class /*subclass of MHObject*/)resultClass {
    return [[WBHTTPService shareHttpService] enqueueRequest:self resultClass:resultClass];
}
@end

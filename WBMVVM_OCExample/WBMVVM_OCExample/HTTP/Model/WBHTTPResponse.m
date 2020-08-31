//
//  WBHTTPResponse.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBHTTPResponse.h"

@interface WBHTTPResponse ()

/// The parsed WBModel object corresponding to the API response.
/// The developer need care this data 切记：若没有数据是NSNull 而不是nil .对应于服务器json数据的 data
@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码 对应于服务器json数据的 code
@property (nonatomic, readwrite, assign) WBHTTPResponseCode code;
/// 自己服务器返回的信息 对应于服务器json数据的 code
@property (nonatomic, readwrite, copy) NSString *msg;


@end

@implementation WBHTTPResponse


- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult {
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult ? : NSNull.null;
        self.code = [responseObject[WBHTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[WBHTTPServiceResponseMsgKey];
    }
    return self;
}

@end

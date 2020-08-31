//
//  WBHTTPResponse.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBHTTPServiceConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBHTTPResponse : NSObject

/// The parsed WBModel object corresponding to the API response.
/// The developer need care this data 切记：若没有数据是NSNull 而不是nil .对应于服务器json数据的 data
@property (nonatomic, readonly, strong) id parsedResult;
/// 自己服务器返回的状态码 对应于服务器json数据的 code
@property (nonatomic, readonly, assign) WBHTTPResponseCode code;
/// 自己服务器返回的信息 对应于服务器json数据的 code
@property (nonatomic, readonly, copy) NSString *msg;

// Initializes the receiver with the headers from the given response, and given the origin data and the
// given parsed model object(s).
- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult;

@end

NS_ASSUME_NONNULL_END

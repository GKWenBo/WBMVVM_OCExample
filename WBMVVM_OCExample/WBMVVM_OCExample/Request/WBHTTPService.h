//
//  WBHTTPService.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBHTTPService : AFHTTPSessionManager

+ (instancetype)shareHttpService;

@end

NS_ASSUME_NONNULL_END

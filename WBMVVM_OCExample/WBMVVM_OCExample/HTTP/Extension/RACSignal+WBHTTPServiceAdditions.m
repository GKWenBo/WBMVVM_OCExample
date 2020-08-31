//
//  RACSignal+WBHTTPServiceAdditions.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "RACSignal+WBHTTPServiceAdditions.h"
#import "WBHTTPResponse.h"
#import "WBModel.h"

@implementation RACSignal (WBHTTPServiceAdditions)

- (RACSignal *)wb_parsedResults {
    return [self map:^id _Nullable(WBHTTPResponse *response) {
        NSAssert([response.parsedResult isKindOfClass:[WBModel class]], @"Expected %@ to be an MHHTTPResponse.", response);
        return response.parsedResult;
    }];
}

@end

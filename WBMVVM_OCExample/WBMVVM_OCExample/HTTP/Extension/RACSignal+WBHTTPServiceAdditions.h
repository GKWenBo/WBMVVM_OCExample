//
//  RACSignal+WBHTTPServiceAdditions.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (WBHTTPServiceAdditions)

// This method assumes that the receiver is a signal of MHHTTPResponses.
//
// Returns a signal that maps the receiver to become a signal of
// WBHTTPResponse.parsedResult.
- (RACSignal *)wb_parsedResults;

@end

NS_ASSUME_NONNULL_END

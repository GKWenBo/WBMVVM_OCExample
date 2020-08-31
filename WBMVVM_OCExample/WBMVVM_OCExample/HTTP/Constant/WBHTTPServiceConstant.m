//
//  WBHTTPServiceConstant.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBHTTPServiceConstant.h"

@implementation WBHTTPServiceConstant

// The domain for all errors originating in WBHTTPService.
NSString *const WBHTTPServiceErrorDomain = @"WBHTTPServiceErrorDomain";
NSString *const WBHTTPServiceErrorHTTPPResponseStatusCodeKey = @"WBHTTPServiceErrorHTTPPResponseStatusCodeKey";
NSString *const WBHTTPServiceErrorHTTPPResponseMsgKey = @"WBHTTPServiceErrorHTTPPResponseMsgKey";

// A user info key associated with the NSURL of the request that failed.
NSString *const WBHTTPServiceErrorRequestURLKey = @"WBHTTPServiceErrorRequestURLKey";
// A user info key associated with an NSNumber, indicating the HTTP status code
// that was returned with the error.
NSString *const WBHTTPServiceErrorHTTPStatusCodeKey = @"WBHTTPServiceErrorHTTPStatusCodeKey";
/// The descriptive message returned from the API, e.g., "Validation Failed".
NSString *const WBHTTPServiceErrorDescriptionKey = @"WBHTTPServiceErrorDescriptionKey";
/// An array of specific message strings returned from the API, e.g.,
/// "No commits between joshaber:master and joshaber:feature".
NSString *const WBHTTPServiceErrorMessagesKey = @"WBHTTPServiceErrorMessagesKey";
NSString *const WBHTTPServiceErrorResponseCodeKey = @"WBHTTPServiceErrorResponseCodeKey";

/// 连接服务器失败 default
NSInteger const WBHTTPServiceErrorConnectionFailed = 668;

NSInteger const WBHTTPServiceErrorJSONParsingFailed = 669;
// The request was invalid (HTTP error 400).
NSInteger const WBHTTPServiceErrorBadRequest = 670;
// The server is refusing to process the request because of an
// authentication-related issue (HTTP error 403).
//
// Often, this means that there have been too many failed attempts to
// authenticate. Even a successful authentication will not work while this error
// code is being returned. The only recourse is to stop trying and wait for
// a bit.
NSInteger const WBHTTPServiceErrorRequestForbidden = 671;
// The server refused to process the request (HTTP error 422)
NSInteger const WBHTTPServiceErrorServiceRequestFailed = 672;
// There was a problem establishing a secure connection, although the server is
// reachable.
NSInteger const WBHTTPServiceErrorSecureConnectionFailed = 673;

NSString *const WBHTTPServiceTokenKey = @"token";
NSString *const WBHTTPServicePrivateKey = @"";
NSString *const WBHTTPServiePrivateValue = @"";
NSString *const WBHTTPServieSignKey = @"sign";
NSString *const WBHTTPServiceResponseCodeKey = @"code";
NSString *const WBHTTPServiceResponseDataKey = @"data";
NSString *const WBHTTPServiceResponseMsgKey = @"msg";
NSString *const WBHTTPServiceResponseListKey = @"list";

// MARK: - 请求Method
NSString *const WB_HTTP_METGID_GET = @"GET";
NSString *const WB_HTTP_METGID_POST = @"POST";
NSString *const WB_HTTP_METGID_PUT = @"PUT";
NSString *const WB_HTTP_METGID_HEAD = @"HEAD";
NSString *const WB_HTTP_METGID_DELETE = @"DELETE";
NSString *const WB_HTTP_METGID_PATCH = @"DELETE";

@end

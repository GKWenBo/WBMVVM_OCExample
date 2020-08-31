//
//  WBHTTPServiceConstant.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WBHTTPResponseCode) {
    WBHTTPResponseCodeSuccess = 1,
    WBHTTPResponseCodeNotLogin,
    WBHTTPResponseCodeParametersVerifyFailure
};

NS_ASSUME_NONNULL_BEGIN

@interface WBHTTPServiceConstant : NSObject

// The domain for all errors originating in WBHTTPService.
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorDomain;
///
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorHTTPPResponseStatusCodeKey;
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorHTTPPResponseMsgKey;

// A user info key associated with the NSURL of the request that failed.
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorRequestURLKey;
// A user info key associated with an NSNumber, indicating the HTTP status code
// that was returned with the error.
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorHTTPStatusCodeKey;
/// The descriptive message returned from the API, e.g., "Validation Failed".
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorDescriptionKey;
/// An array of specific message strings returned from the API, e.g.,
/// "No commits between joshaber:master and joshaber:feature".
FOUNDATION_EXTERN NSString *const WBHTTPServiceErrorMessagesKey;
FOUNDATION_EXPORT NSString *const WBHTTPServiceErrorResponseCodeKey;


/// 连接服务器失败 default
FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorConnectionFailed;

FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorJSONParsingFailed;
// The request was invalid (HTTP error 400).
FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorBadRequest;
// The server is refusing to process the request because of an
// authentication-related issue (HTTP error 403).
//
// Often, this means that there have been too many failed attempts to
// authenticate. Even a successful authentication will not work while this error
// code is being returned. The only recourse is to stop trying and wait for
// a bit.
FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorRequestForbidden;
// The server refused to process the request (HTTP error 422)
FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorServiceRequestFailed;
// There was a problem establishing a secure connection, although the server is
// reachable.
FOUNDATION_EXTERN NSInteger const WBHTTPServiceErrorSecureConnectionFailed;

// MARK: - 服务器响应key
/// "token"
FOUNDATION_EXTERN NSString *const WBHTTPServiceTokenKey;
/// WBHTTPServicePrivateKey
FOUNDATION_EXTERN NSString *const WBHTTPServicePrivateKey;
/// WBHTTPServiePrivateValue
FOUNDATION_EXTERN NSString *const WBHTTPServiePrivateValue;
/// "sign"
FOUNDATION_EXTERN NSString *const WBHTTPServieSignKey;
/// "code"
FOUNDATION_EXTERN NSString *const WBHTTPServiceResponseCodeKey;
/// "data"
FOUNDATION_EXTERN NSString *const WBHTTPServiceResponseDataKey;
/// "msg"
FOUNDATION_EXTERN NSString *const WBHTTPServiceResponseMsgKey;
/// "list"
FOUNDATION_EXTERN NSString *const WBHTTPServiceResponseListKey;

// MARK: - 请求Method
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_GET;
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_POST;
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_PUT;
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_HEAD;
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_DELETE;
FOUNDATION_EXTERN NSString *const WB_HTTP_METGID_PATCH;

@end

NS_ASSUME_NONNULL_END

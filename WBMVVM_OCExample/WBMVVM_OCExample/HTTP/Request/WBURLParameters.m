//
//  WBURLParameters.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBURLParameters.h"

@implementation WBURLExtendsParameters

+ (instancetype)extendsParameters {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)ver {
    static NSString *version = nil;
    if (version == nil) version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return (version.length > 0) ? version : @"";
}

- (NSString *)token {
    return @"";
}

- (NSString *)deviceid {
//    static NSString *deviceidStr = nil;
//    if (deviceidStr == nil) deviceidStr = [SAMKeychain deviceId];
//    return deviceidStr.length>0?deviceidStr:@"";
    return @"";
}

- (NSString *)platform{
    return @"iOS";
}

- (NSString *)channel{
    return @"AppStore";
}

- (NSString *)t {
    return [NSString stringWithFormat:@"%.f", [NSDate date].timeIntervalSince1970];
}

@end

@implementation WBURLParameters

+ (instancetype)urlParametersWithMethod:(NSString *)method
                                   path:(NSString *)path
                             parameters:(NSDictionary *)parameters {
    return [[self alloc] initUrlParametersWithMethod:method
                                                path:path
                                          parameters:parameters];
}

- (instancetype)initUrlParametersWithMethod:(NSString *)method
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        self.method = method;
        self.path = path;
        self.parameters = parameters;
        self.extendsParameters = [[WBURLExtendsParameters alloc] init];
    }
    return self;
}

@end

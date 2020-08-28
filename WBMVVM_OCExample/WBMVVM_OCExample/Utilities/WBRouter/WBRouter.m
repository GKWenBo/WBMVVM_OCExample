//
//  WBRouter.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBRouter.h"

@interface WBRouter ()

/// viewModel到viewController的映射
@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation WBRouter

static WBRouter *sharedInstance_ = nil;

+ (instancetype)shareRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc]init];
    });
    return sharedInstance_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return sharedInstance_;
}

- (WBViewController *)viewControllerForViewModel:(WBViewModel *)viewModel {
    NSString *className = NSStringFromClass([viewModel class]);
    
    NSParameterAssert([NSClassFromString(className) isSubclassOfClass:[WBViewController class]]);
    NSParameterAssert([NSClassFromString(className) respondsToSelector:@selector(initWithViewModel:)]);
    return [[NSClassFromString(className) alloc] initWithViewModel:viewModel];
}


// MARK: - getter
/// 这里是viewModel -> ViewController的映射
/// If You Use Push 、 Present 、 ResetRootViewController ,You Must Config This Dict
- (NSDictionary *)viewModelViewMappings {
    return @{};
}

@end

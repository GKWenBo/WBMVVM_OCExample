//
//  WBViewModel.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBViewModel.h"
/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
NSString *const WBViewModelIDKey = @"WBViewModelIDKey";
/// 传递导航栏title的key：例如 导航栏的title...
NSString *const WBViewModelTitleKey = @"WBViewModelTitleKey";
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
NSString *const WBViewModelUtilKey = @"WBViewModelUtilKey";
/// 传递webView Request的key：例如 webView request...
NSString *const WBViewModelRequestKey = @"WBViewModelRequestKey";

@interface WBViewModel ()

/// 整个应用的服务层 The `services` parameter in `-initWithServices:params` method.
@property (nonatomic, strong, readwrite) id<WBViewModelServices> services;
/// The `params` parameter in `-initWithServices:params` method.
@property (nonatomic, readwrite, copy) NSDictionary *params;
/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readwrite, strong) RACSubject *errors;
/// The `View` willDisappearSignal
@property (nonatomic, readwrite, strong) RACSubject *willDisappearSignal;

@end

@implementation WBViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    WBViewModel *viewModel = [super allocWithZone:zone];
    @weakify(viewModel);
    [[viewModel rac_signalForSelector:@selector(initWithServices:params:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    return viewModel;
}

- (instancetype)initWithServices:(id<WBViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super init]) {
        /// 默认在viewDidLoad里面加载本地和服务器的数据
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        /// 允许IQKeyboardMananger接管键盘弹出事件
        self.keyboardEnable = YES;
        self.shouldResignOnTouchOutside = YES;
        self.keyboardDistanceFromTextField = 10.0f;
        self.prefersNavigationBarBottomLineHidden = YES;
                
        self.title = params[WBViewModelTitleKey];
        /// 赋值
        self.services = services;
        self.params   = params;
    }
    return self;
}

- (void)initialize {}

// MARK: - getter
- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) {
        _willDisappearSignal = [RACSubject subject];
    }
    return _willDisappearSignal;;
}

@end

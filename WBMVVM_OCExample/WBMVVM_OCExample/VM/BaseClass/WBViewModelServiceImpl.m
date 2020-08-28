//
//  WBViewModelServiceImpl.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBViewModelServiceImpl.h"

@implementation WBViewModelServiceImpl

@synthesize client = _client;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [WBHTTPService shareHttpService];
    }
    return self;
}

// MARK: - WBViewModelService
- (void)pushViewModel:(WBViewModel *)viewModel animated:(BOOL)animated {}
- (void)popViewModelAnimated:(BOOL)animated {}
- (void)popToRootViewModelAnimated:(BOOL)animated {}
- (void)presentViewModel:(WBViewModel *)viewModel animated:(BOOL)animated completion:(WBVoidBlock)completion {}
- (void)dismissViewModelAnimated:(BOOL)animated completion:(WBVoidBlock)completion {}
- (void)resetRootViewModel:(WBViewModel *)viewModel {}

@end

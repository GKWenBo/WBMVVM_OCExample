//
//  WBViewControllerProtocol.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBViewControllerProtocol <NSObject>

@optional
- (void)bindViewModel;
- (void)makeUI;
/// 设置导航栏
- (void)layoutNavigation;

@end

NS_ASSUME_NONNULL_END

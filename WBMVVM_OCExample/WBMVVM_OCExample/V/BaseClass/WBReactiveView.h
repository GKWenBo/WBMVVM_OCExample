//
//  WBReactiveView.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBReactiveView <NSObject>

@optional
- (void)makeUI;
- (void)bindViewModel:(id)viewModel;
- (instancetype)initWithViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END

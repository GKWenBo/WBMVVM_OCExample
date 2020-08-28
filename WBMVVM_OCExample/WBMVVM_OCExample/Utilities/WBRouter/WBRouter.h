//
//  WBRouter.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBRouter : NSObject

+ (instancetype)shareRouter;

- (WBViewController *)viewControllerForViewModel:(WBViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

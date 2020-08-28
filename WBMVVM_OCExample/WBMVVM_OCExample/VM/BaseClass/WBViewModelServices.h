//
//  WBViewModelService.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBNavigatorProtocol.h"
#import "WBHTTPService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBViewModelServices <NSObject, WBNavigatorProtocol>

@property (nonatomic, strong, readonly) WBHTTPService *client;

@end

NS_ASSUME_NONNULL_END

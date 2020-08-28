//
//  AppDelegate.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBNavigationControllerStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// APP管理的导航栏的堆栈
@property (nonatomic, readonly, strong) WBNavigationControllerStack *navigationControllerStack;

@end

